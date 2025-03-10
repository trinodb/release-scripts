#!/bin/bash

set -eux

VERSION=$1
REGISTRY=trinodb
architectures=(amd64 arm64 ppc64le)
packages=(trino-server-core trino-server)
tags=(trino-core trino)

for index in "${!packages[@]}"; do
    TAG=${tags[$index]}
    TARGET=$REGISTRY/$TAG:$VERSION
    core/docker/build.sh -a "$(IFS=, ; echo "${architectures[*]}")" -r "$VERSION" -p "${packages[$index]}" -t "$TAG"

    for arch in "${architectures[@]}"; do
        docker tag "$TAG:$VERSION-$arch" "$TARGET-$arch"
        docker push "$TARGET-$arch"
    done

    for name in "$TARGET" "$REGISTRY/$TAG:latest"; do
        docker manifest create "$name" "${architectures[@]/#/$TARGET-}"
        docker manifest push --purge "$name"
    done
done
