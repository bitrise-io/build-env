# Bitrise build env package

Bitrise building environment for internal services. Contains pre-installed tools to facilitate microservice & infrastructure workflows. Bitrise infrastructure is fully handled with official steplib cached.

## Preinstalled packages

* gcloud CLI
  * python
* kubectl
* go
* tfswitch + terraform
* bitrise CLI
* nodejs
* tfsec (github.com/tfsec/tfsec/cmd/tfsec)

### Preinstalled GO packages

* github.com/kisielk/errcheck
* golang.org/x/lint/golint

## Environment initializer Step

Beside preinstalled tools this package also contains an environment initializer step which takes care of multiple things. Every step is optional, depending on
whether you specify or not the corresponging inputs:

* __GCLOUD_KEY__: Setup and authenticate gcloud CLI from a service user key (optional)
* __GKE_CLUSTER__: Setup a specific cluster to kubectl (optional)
* __GKE_CLUSTER_REGION__: Region of specific cluster (only regional supported - optional)
* __TERRAFORM_DIR__: Initializes terraform in a specific directory (optional)
* __TERRAFORM_SECRETS__: Creates "secrets.auto.tfvars" file from secret env vars (optional)
* __TERRAFORM_WORKSPACE__: Initializes specific terraform workspace (optional)

Terraform initialization checks if a backend configuration file with the name `$TERRAFORM_WORKSPACE-backend.tfvars` is present. If such config file is found, it is passed to the init command. This can be used to set the remote terraform backend's bucket.

Please note that using terraform initialization for an empty non-default (e.g. staging) workspace is not supported. Manually init the workspace first, then you can use it with this tool.

It will choose the current terraform version based on the requirement specified in your terraform code. Highly recommended to specify the version!. Example:

```terraform
terraform {
  required_version = "= 0.14.7"
}
```

__Preinstalled version:__ 0.14.7


## Usage in bitrise workflow:

```yaml
- git::https://github.com/bitrise-io/build-env@master:
    title: Set up environment
    run_if: $.IsCI
    inputs:
      - SERVICE_NAME: $SERVICE_NAME
      - GCLOUD_KEY: $GCLOUD_KEY
      - GKE_CLUSTER: $GKE_CLUSTER
      - GKE_CLUSTER_REGION: $REGION
      - TERRAFORM_DIR: $BITRISE_SOURCE_DIR/infra
      - TERRAFORM_SECRETS: "$TF_SECRETS"
```
