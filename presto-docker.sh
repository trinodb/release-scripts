#!/bin/sh

set -eux

VERSION=$1
NAME=prestosql/presto
IMAGE=presto:$VERSION

docker/build-remote.sh $VERSION
docker tag $IMAGE $NAME:latest
docker push $NAME:latest
docker tag $IMAGE $NAME:$VERSION
docker push $NAME:$VERSION
