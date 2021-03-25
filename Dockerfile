FROM bitriseio/bitrise-base-20.04:latest

ENV GO_VERSION=1.15.7 \
    TERRAFORM_VERSION=0.14.7 \
    HELM_VERSION=3.5.0 \
    GCLOUD_VERSION=320.0.0 \
    # overriding GOPATH so we'll preserve pre-installed packages
    GOPATH=$HOME/go \
    GOBIN=$HOME/go/bin

ADD ./scripts/* /tmp/

# install additional tools
RUN /tmp/update_go.sh \
    && /tmp/install_gcloud_cli.sh \
    && /tmp/install_helm.sh \
    # && /tmp/install_argo.sh \
    && /tmp/install_terraform.sh \
    && rm -rf /var/cache/apt \
    && apt-get clean

ENV PATH=$GOBIN:$PATH:/usr/local/google-cloud-sdk/bin

# install go dependencies
RUN mkdir -p $GOPATH \
    && go get -u github.com/kisielk/errcheck \
    && go get -u github.com/tfsec/tfsec/cmd/tfsec \
    && go get -u golang.org/x/lint/golint
