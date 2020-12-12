FROM bitriseio/docker-bitrise-base:latest

ENV GO_VERSION=1.15.6 \
    TERRAFORM_VERSION=0.13.5 \
    GOBIN=$GOPATH/bin

ADD ./scripts/* /tmp/

RUN /tmp/update_go.sh \
    && /tmp/install_gcloud_cli.sh \
    && /tmp/install_helm.sh \
    # && /tmp/install_argo.sh \
    && /tmp/install_terraform.sh \
    && rm -rf /var/cache/apt \
    && apt-get clean

ENV PATH=$PATH:/usr/local/google-cloud-sdk/bin:${GOBIN}

RUN go get -u github.com/kisielk/errcheck \
    && go get -u github.com/tfsec/tfsec/cmd/tfsec \
    && go get -u golang.org/x/lint/golint
