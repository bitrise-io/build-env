#!/usr/bin/env bash

# get helm installation file
curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz

# extract it
tar -xvzf helm-v${HELM_VERSION}-linux-amd64.tar.gz

# move it to appropriate place
mv linux-amd64/helm /usr/local/bin/helm

# remove folder
rm -rf linux-amd64/

# install github release plugin
helm plugin install https://github.com/web-seven/helm-github.git
