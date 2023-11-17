#!/bin/sh

set -eu

VERSION=$1

REPOSITORY=$HOME/.m2/repository
GROUP=io.trino
ARTIFACT=trino-docs

GROUPDIR=$(echo $GROUP | tr . /)

CENTRAL=central::default::https://repo1.maven.org/maven2

GOOGLE_GA4_ID=G-RJ94STKPJ5
GOOGLE_UA_ID=UA-133457846-1
AUDIENCE_ID=AW-1036784065
LINKEDIN_ID=2842796

if [ -e "$VERSION" ]; then
    echo "already exists: $VERSION"
    exit 100
fi

mvn org.apache.maven.plugins:maven-dependency-plugin:2.8:get \
    -Dartifact=$GROUP:$ARTIFACT:$VERSION:zip -DremoteRepositories=$CENTRAL

unzip "$REPOSITORY/$GROUPDIR/$ARTIFACT/$VERSION/$ARTIFACT-$VERSION.zip"

mv html "$VERSION"

find -H "$VERSION" -type f -name '*.html' -print0 | xargs -0 perl -pi -e \
    "s@</head>
@  <script async src=\"https://www.googletagmanager.com/gtag/js?id=$GOOGLE_GA4_ID\"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', '$GOOGLE_GA4_ID');
      gtag('config', '$GOOGLE_UA_ID');
      gtag('config', '$AUDIENCE_ID');
      window._linkedin_data_partner_ids = ['$LINKEDIN_ID'];
    </script>
    <script async src=\"https://snap.licdn.com/li.lms-analytics/insight.min.js\"></script>
  </head>
@;
s@<style>
@<link href=\"https://fonts.googleapis.com/css2?family=Alata&family=Open+Sans:ital,wght%400,300;0,400;0,600;1,400&display=swap\" rel=\"stylesheet\">
    <style>
@;
s@<a href=\"[^\"]*\" title=\"Trino $VERSION Documentation\"@<a href=\"/\" title=\"Trino\"@;
"

echo "/current/* /$VERSION/:splat 200" >_redirects
/bin/ln -sfh "$VERSION" current

git add "$VERSION" _redirects current

git commit -m "Add $VERSION docs"
