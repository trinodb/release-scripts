#!/bin/sh

set -eu

CURRENT=$1

git log --format='%<|(21)%cn %<|(39)%cd %<|(50)%h %s' --date=format-local:'%m-%d %H:%M:%S' $CURRENT.. | \
    grep -vF '[maven-release-plugin]' | sort | \
    awk '
{
  name = substr($0, 1, 21)
  if (name != current) {
    print "## " name
    print "- [ ] all checked"
  }
  {
    current = name
    print "- " substr($0, 22)
  }
}
'
