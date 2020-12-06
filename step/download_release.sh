#!/usr/bin/env bash

####################################
## Based on https://gist.github.com/metral/464b179b584ccc0887de580f97e56ae1
####################################

VERSION=${1##*/}
REPO=${1%%/$VERSION}
FILE="$VERSION.tgz"
GITHUB="https://api.github.com"


if [ -z "$GITHUB_TOKEN" ]; then
echo "Please set GITHUB_TOKEN environment variable in order to download Github releases! (secret)"
exit 1
fi

function gh_curl() {
  curl -H "Authorization: token $GITHUB_TOKEN" \
       -H "Accept: application/vnd.github.v3.raw" \
       $@
}

if [ "$VERSION" = "latest" ]; then
  # Github should return the latest release first.
  parser=".[0].assets | map(select(.name == \"$FILE\"))[0].id"
else
  parser=". | map(select(.tag_name == \"$VERSION\"))[0].assets | map(select(.name == \"$FILE\"))[0].id"
fi;

asset_id=$(gh_curl -s $GITHUB/repos/$REPO/releases | jq "$parser")
if [ "$asset_id" = "null" ]; then
  >&2 echo "ERROR: version not found $VERSION"
  exit 1
fi;

curl -sSL -H 'Accept:application/octet-stream' https://$GITHUB_TOKEN:@api.github.com/repos/$REPO/releases/assets/$asset_id -o /tmp/$FILE

echo /tmp/$FILE