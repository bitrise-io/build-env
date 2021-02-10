#!/usr/bin/env bash
echo -n $GCLOUD_KEY > /tmp/gcloud_key.json

WD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GCLOUD_PROJECT=$(echo -n $GCLOUD_KEY | jq -r '.project_id')
GCLOUD_USER=$(echo -n $GCLOUD_KEY | jq -r '.client_email')

echo "Authenticating $GCLOUD_USER to $GCLOUD_PROJECT project..."

export GOOGLE_APPLICATION_CREDENTIALS=/tmp/gcloud_key.json

gcloud auth activate-service-account $GCLOUD_USER --key-file=/tmp/gcloud_key.json
gcloud config set project $GCLOUD_PROJECT
gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://gcr.io

if [ ! -z "$GKE_CLUSTER" ]; then
echo "Setting up access to $GKE_CLUSTER..."

# setup kubectl access
gcloud container clusters get-credentials --region=$GKE_CLUSTER_REGION $GKE_CLUSTER
fi


if [ ! -z "$TERRAFORM_DIR" ]; then
echo "Initializing terraform in $TERRAFORM_DIR..."
pushd $TERRAFORM_DIR
terraform init
popd
fi

if [ ! -z "$TERRAFORM_SECRETS" ] && [ ! -z "$TERRAFORM_DIR" ]; then
echo "Copying terraform secrets to $TERRAFORM_DIR/secrets.auto.tfvars"

# Quoting variables in bash preserves the whitespace.
echo "$TERRAFORM_SECRETS" > "$TERRAFORM_DIR/secrets.auto.tfvars"
elif [ -z "$TERRAFORM_DIR" ]; then
echo "You need to specify TERRAFORM_DIR input with TERRAFORM_SECRETS"
fi

if [ ! -z "$HELM_REPO" ]; then
echo "Adding $HELM_REPO helm repository..."
helm repo add main $HELM_REPO
helm repo update
fi

# Outputs
envman add --key SERVICE_IMAGE_ID --value "gcr.io/$GCLOUD_PROJECT/$SERVICE_NAME:$BITRISE_BUILD_NUMBER"
envman add --key GCLOUD_PROJECT --value $GCLOUD_PROJECT
envman add --key GCLOUD_USER --value $GCLOUD_USER
envman add --key GOOGLE_APPLICATION_CREDENTIALS --value $GOOGLE_APPLICATION_CREDENTIALS
