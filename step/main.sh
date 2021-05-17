#!/usr/bin/env bash
set -e

WD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -z "$GCLOUD_KEY" ]; then
echo -n $GCLOUD_KEY > /tmp/gcloud_key.json

GCLOUD_PROJECT=$(echo -n $GCLOUD_KEY | jq -r '.project_id')
GCLOUD_USER=$(echo -n $GCLOUD_KEY | jq -r '.client_email')

echo "Authenticating $GCLOUD_USER to $GCLOUD_PROJECT project..."

export GOOGLE_APPLICATION_CREDENTIALS=/tmp/gcloud_key.json

gcloud auth activate-service-account $GCLOUD_USER --key-file=/tmp/gcloud_key.json
gcloud config set project $GCLOUD_PROJECT

for REG in "gcr.io" "us.gcr.io"; do
gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://$REG
done

fi

if [ ! -z "$GKE_CLUSTER" ]; then
echo "Setting up access to $GKE_CLUSTER..."

# setup kubectl access
gcloud container clusters get-credentials --region=$GKE_CLUSTER_REGION $GKE_CLUSTER
fi


if [ ! -z "$TERRAFORM_DIR" ]; then
echo "Initializing terraform in $TERRAFORM_DIR... using $TERRAFORM_WORKSPACE"
pushd $TERRAFORM_DIR

# use the correct terraform version
tfswitch

backend_config_file="$TERRAFORM_WORKSPACE-backend.tfvars"
if [[ -f "$backend_config_file" ]]; then
echo "Terraform backend config file found: $backend_config_file"
terraform init -backend-config=$backend_config_file
else
terraform init
fi

terraform workspace select $TERRAFORM_WORKSPACE

# increases envman environment bytes limit (useful for large TF plans)
mkdir -p ~/.envman && echo -e '{"env_bytes_limit_in_kb": 60}' > ~/.envman/configs.json
popd
fi

if [ ! -z "$TERRAFORM_SECRETS" ] && [ ! -z "$TERRAFORM_DIR" ]; then
echo "Copying terraform secrets to $TERRAFORM_DIR/secrets.auto.tfvars"

# Quoting variables in bash preserves the whitespace.
echo "$TERRAFORM_SECRETS" > "$TERRAFORM_DIR/secrets.auto.tfvars"
elif [ -z "$TERRAFORM_DIR" ]; then
echo "You need to specify TERRAFORM_DIR input with TERRAFORM_SECRETS"
fi

# Outputs
if [ ! -z "$GCLOUD_PROJECT" ]; then
SERVICE_IMAGE_ID="gcr.io/$GCLOUD_PROJECT/$SERVICE_NAME:$BITRISE_BUILD_NUMBER"
fi

envman add --key SERVICE_IMAGE_ID --value "$SERVICE_IMAGE_ID"
envman add --key GCLOUD_PROJECT --value "$GCLOUD_PROJECT"
envman add --key GCLOUD_USER --value "$GCLOUD_USER"
envman add --key GOOGLE_APPLICATION_CREDENTIALS --value "$GOOGLE_APPLICATION_CREDENTIALS"
