#!/bin/bash
set -ex

echo -n $GCLOUD_KEY > /tmp/gcloud_key.json

GCLOUD_PROJECT=$(echo -n $GCLOUD_KEY | jq '.project_id')
GCLOUD_USER=$(echo -n $GCLOUD_KEY | jq '.client_email')

echo "Authenticating $GCLOUD_USER to $GCLOUD_PROJECT project..."

gcloud auth activate-service-account $GCLOUD_USER --key-file=/tmp/gcloud_key.json
gcloud config set project $GCLOUD_PROJECT
gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://gcr.io

if [ -z "$GKE_CLUSTER" ] then
echo "Setting up access to $GKE_CLUSTER..."

# setup kubectl access
gcloud container clusters get-credentials --zone=us-central1-a $GKE_CLUSTER
fi


if [ -z "$TERRAFORM_DIR" ] then
pushd $TERRAFORM_DIR
terraform init
popd
fi

# Outputs
envman add --key GCLOUD_PROJECT --value $GCLOUD_PROJECT
envman add --key GCLOUD_USER --value $GCLOUD_USER
