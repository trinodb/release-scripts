#!/bin/sh

set -eu

VERSION=$1

perl -pi -e 's/trino_version: \d+/trino_version: '"$VERSION"'/g' _config.yml

git add _config.yml

git commit -m "Update to Trino $VERSION"
