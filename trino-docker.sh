#!/bin/sh

set -eux

VERSION=$1
REPO=trinodb/trino
IMAGE=trino:$VERSION
TARGET=$REPO:$VERSION

core/docker/build.sh -r "$VERSION"

docker tag "$IMAGE-amd64" "$TARGET-amd64"
docker tag "$IMAGE-arm64" "$TARGET-arm64"
docker push "$TARGET-amd64"
docker push "$TARGET-arm64"

for name in "$TARGET" "$REPO:latest"; do
    docker manifest create "$name" "$TARGET-amd64" "$TARGET-arm64"
    docker manifest push --purge "$name"
done
