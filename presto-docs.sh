#!/bin/sh

set -eu

VERSION=$1

REPOSITORY=$HOME/.m2/repository
GROUP=io.prestosql
ARTIFACT=presto-docs

GROUPDIR=$(echo $GROUP | tr . /)

CENTRAL=central::default::https://repo1.maven.org/maven2

TRACKINGID=UA-133457846-1

if [ -e $VERSION ]
then
   echo "already exists: $VERSION"
   exit 100
fi

mvn org.apache.maven.plugins:maven-dependency-plugin:2.8:get \
  -Dartifact=$GROUP:$ARTIFACT:$VERSION:zip -DremoteRepositories=$CENTRAL

unzip $REPOSITORY/$GROUPDIR/$ARTIFACT/$VERSION/$ARTIFACT-$VERSION.zip

mv html $VERSION

find -H $VERSION -type f -name '*.html' -print0 | xargs -0 perl -pi -e \
"s@</head>
@  <script async src=\"https://www.googletagmanager.com/gtag/js?id=$TRACKINGID\"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', '$TRACKINGID');
    </script>
  </head>
@"

find -H $VERSION -type f -name '*.html' -print0 | xargs -0 perl -pi -e \
"s@<div class=\"header\">
@<div class=\"header\">
    <span style=\"float: right; margin-top: 20px;\">
        <a href=\"/slack.html\">
            <img height=\"24\" src=\"https://img.shields.io/badge/Slack-ask%20for%20help-44af5c.svg?logo=slack\">
        </a>
    </span>
@"

perl -pi -e 's@<loc>/index.html@<loc>/@g' $VERSION/sitemap.xml
perl -pi -e 's@<loc>@<loc>https://prestosql.io/docs/current@g' $VERSION/sitemap.xml

echo "/current/* /$VERSION/:splat 200" > _redirects
/bin/ln -sfh $VERSION current

git add $VERSION _redirects current

git commit -m "Add $VERSION docs"
