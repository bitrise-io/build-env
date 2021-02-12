# Bitrise build env package

Bitrise building environment for internal services. Contains pre-installed tools to facilitate microservice & infrastructure workflows. Bitrise infrastructure is fully handled with official steplib cached.

## Preinstalled packages

* gcloud CLI
  * python
* kubectl
* helm
* go
* terraform
* bitrise CLI
* nodejs
* (argo-CD CLI coming later)
* tfsec (github.com/tfsec/tfsec/cmd/tfsec)

### Preinstalled GO packages

* github.com/kisielk/errcheck
* golang.org/x/lint/golint

## Environment initializer Step

Beside preinstalled tools this package also contains and environment initializer step which takes care of multiple things. Every step is optional, depending on
whether you specify or not the corresponging inputs:

* __GCLOUD_KEY__: Setup and authenticate gcloud CLI from a service user key
* __GKE_CLUSTER__: Setup a specific cluster to kubectl
* __GKE_CLUSTER_REGION__: Region of specific cluster (only regional supported)
* __TERRAFORM_DIR__: Initializes terraform in a specific directory
* __TERRAFORM_SECRETS__: Creates "secrets.auto.tfvars" file from secret env vars
* __TERRAFORM_WORKSPACE__: Initializes specific terraform workspace
* __HELM_REPO__: Setup and initializes helm repository. [helm GH downloader](https://github.com/web-seven/helm-github.git) is preinstalled.

Usage in bitrise workflow:

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
      - HELM_REPO: $HELM_REPO
```

### Note on private Helm github repositories

In order to download private releases you need to set `$GITHUB_TOKEN` env var which should be a github access token. More on this: [https://github.com/settings/tokens](https://github.com/settings/tokens)
