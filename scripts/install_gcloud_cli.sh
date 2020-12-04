#!/usr/bin/env bash

GCLOUD_INSTALL=google-cloud-sdk-293.0.0-linux-x86_64.tar.gz

# download binary
curl -sSL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/$GCLOUD_INSTALL -o $GCLOUD_INSTALL

# extract it
tar -C /usr/local -xzf $GCLOUD_INSTALL

# remove install
rm $GCLOUD_INSTALL
