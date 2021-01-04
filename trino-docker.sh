#!/bin/sh

set -eux

VERSION=$1
NAME=trinodb/trino
IMAGE=trino:$VERSION

core/docker/build-remote.sh $VERSION
docker tag $IMAGE $NAME:latest
docker push $NAME:latest
docker tag $IMAGE $NAME:$VERSION
docker push $NAME:$VERSION
