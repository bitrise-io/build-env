#!/usr/bin/env bash

# get helm installation file
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3

# install gelm
chmod +x get_helm.sh && ./get_helm.sh

# install github release plugin
helm plugin install https://github.com/web-seven/helm-github.git

# remove install file
rm get_helm.sh