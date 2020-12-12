#!/usr/bin/env bash

GCLOUD_INSTALL=google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz

# download binary
curl -sSL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/$GCLOUD_INSTALL -o $GCLOUD_INSTALL

# extract it
tar -C /usr/local -xzf $GCLOUD_INSTALL

# install kubectl
/usr/local/google-cloud-sdk/bin/gcloud components install kubectl --quiet

# remove install
rm $GCLOUD_INSTALL

# remove temp dir
rm -rf /usr/local/google-cloud-sdk/.install/.backup
