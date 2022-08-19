#!/bin/bash

set -eux

VERSION=$1
REPO=trinodb/trino
IMAGE=trino:$VERSION
TARGET=$REPO:$VERSION

core/docker/build.sh -r "$VERSION"

architectures=(amd64 arm64 ppc64le)

for arch in "${architectures[@]}"; do
    docker tag "$IMAGE-$arch" "$TARGET-$arch"
    docker push "$TARGET-$arch"
done

for name in "$TARGET" "$REPO:latest"; do
    docker manifest create "$name" "${architectures[@]/#/$TARGET-}"
    docker manifest push --purge "$name"
done
