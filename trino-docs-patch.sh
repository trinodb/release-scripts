#!/bin/sh

set -eu

VERSION=$1

# Assume trino is checked out in sibling folder of release-scripts
# Also assumed to docs are built in the target/html folder
# TRINO_VERSION must be set before docs build to override SNAPSHOT
PATH_TO_HTML="../trino/docs/target/html/"

TRACKINGID=UA-133457846-1
AUDIENCEID=AW-1036784065
LINKEDINID=2842796
rm -rf $1
rm -rf current
rm -rf _redirects

echo "Removed prior content"

mkdir $1

cp -r $PATH_TO_HTML "$VERSION"
echo "Copied new docs to $VERSION"

find -H "$VERSION" -type f -name '*.html' -print0 | xargs -0 perl -pi -e \
    "s@</head>
@  <script async src=\"https://www.googletagmanager.com/gtag/js?id=$TRACKINGID\"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', '$TRACKINGID');
      gtag('config', '$AUDIENCEID');
      window._linkedin_data_partner_ids = ['$LINKEDINID'];
    </script>
    <script async src=\"https://snap.licdn.com/li.lms-analytics/insight.min.js\"></script>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
  </head>
@;
s@<style>
@<link href=\"https://fonts.googleapis.com/css2?family=Alata&family=Open+Sans:ital,wght%400,300;0,400;0,600;1,400&display=swap\" rel=\"stylesheet\">
    <style>
@;
s@<header class=\"md-header\" data-md-component=\"header\">
@<div id=\"announcement\">
  <div id=\"announcement-content\">
    <a href=\"https://github.com/trinodb/trino\" target=\"_blank\">
      Do you ❤️ Trino? Give us a 🌟 on GitHub <i class=\"fab fa-github\"></i>
    </a>
  </div>
</div>
<header class=\"md-header\" data-md-component=\"header\">
@;
s@</header>@</header>@;
s@<a href=\"[^\"]*\" title=\"Trino $VERSION Documentation\"@<a href=\"/\" title=\"Trino\"@;
"

echo "Updated pages"

cat <<EOT >>$VERSION/_static/trino.css

.md-sidebar { padding-block-start: 75px; }
.md-content { padding-block-start: 50px; }
header.md-header { top: 53px; }
#announcement {
  z-index: 2;
  position: fixed;
  top: 0px;
  width: 100%;
}
#announcement-content {
  background-color: #dd00a1;
  border: 1px;
  color: white;
  text-align: center;
  height: 53px;
  padding: 16px;
  font-family: Alata, sans-serif;
  line-height: 21.6px;
  font-size: 18px;
  font-weight: 300;
  text-rendering: optimizeLegibility !important;
  -webkit-font-smoothing: antialiased !important;
}
#announcement-content a {
  margin-left: 32px;
}
.md-typeset span[id]:target:before {
    margin-top:-92px;
    padding-top:92px;
}
.md-typeset h1[id]:target:before,
.md-typeset h2[id]:target:before,
.md-typeset h3[id]:target:before,
.md-typeset h4[id]:target:before,
.md-typeset h5[id]:target:before,
.md-typeset h6[id]:target:before,
.md-typeset dl[id]:target:before {
    margin-top:-134px;
    padding-top:134px;
}
EOT

echo "Updated stylesheet"

