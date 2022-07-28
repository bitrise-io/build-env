FROM bitriseio/bitrise-base-20.04:latest

ENV GO_VERSION=1.15.15 \
    TERRAFORM_VERSION=0.15.5 \
    GCLOUD_VERSION=394.0.0 \
    # overriding GOPATH so we'll preserve pre-installed packages
    GOPATH=$HOME/go \
    GOBIN=$HOME/go/bin

ADD ./scripts/* /tmp/

# install additional tools
RUN /tmp/update_go.sh \
    && /tmp/install_gcloud_cli.sh \
    && /tmp/install_terraform.sh \
    && rm -rf /var/cache/apt \
    && apt-get clean

ENV PATH=$GOBIN:$PATH:/usr/local/google-cloud-sdk/bin

# install go dependencies
RUN mkdir -p $GOPATH \
    && go get -u github.com/kisielk/errcheck \
    && go get -u golang.org/x/lint/golint

RUN wget 'https://github.com/aquasecurity/tfsec/releases/download/v1.26.3/tfsec-linux-amd64' -O /usr/local/bin/tfsec && chmod +x /usr/local/bin/tfsec

