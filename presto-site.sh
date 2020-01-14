#!/bin/sh

set -eu

VERSION=$1

perl -pi -e 's/presto_version: \d+/presto_version: '$VERSION'/g' _config.yml

git add _config.yml

git commit -m "Update to Presto $VERSION"
