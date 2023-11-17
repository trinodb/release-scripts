# Trino release scripts

A collection of shell scripts to help with the Trino release process. Add the
scripts to your PATH to use them. Commit and push access to the git and
docker repositories is required.

## git changes

Use `git-release-changes.sh` in your local checkout of `trinodb/trino` with the
git revision of first commit after the prior release to list all commits since
then in a formatted output of all commits per maintainer.

This script output can be used to verify each commit for release notes entries.

## Docker container publishing

Use `trino-docker.sh` in your local checkout of `trinodb/trino` after the
release build completed.

Verify the pushed data on https://hub.docker.com/r/trinodb/trino.

## Documentation deployment

Use `trino-docs.sh` in your local checkout of `trinodb/docs.trino.io` with the
version of the release:

```
trino-docs.sh 434
```

Push the changes after verifying locally, and then check the deployed version
on https://trino.io/docs/current/.

## Website update

Use `trino-site.sh` in your local checkout of `trinodb/trino.io` with the
version of the release:

```
trino-site.sh 434
```

Push the changes after verifying locally, and then check the download links on
https://trino.io/download.