FROM ubuntu:18.04

ADD ./scripts/* /tmp/

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    git \
    rsync \
    python \
    sudo \
    expect \
    unzip \
    && curl -qL https://github.com/bitrise-io/bitrise/releases/download/1.44.1/bitrise-$(uname -s)-$(uname -m) -o /usr/local/bin/bitrise \
    && GO_VERSION=1.13.5 /tmp/install_go.sh \
    && /tmp/install_gcloud_cli.sh \
    && /tmp/install_argo.sh \
    && VERSION=0.13.5 /tmp/install_terraform.sh \
    && rm -rf /var/cache/apt

ENV BITRISE_SOURCE_DIR="/bitrise/src"
ENV GOBIN=/usr/local/go/bin
ENV GOPATH=/usr/local/go
ENV PATH=$PATH:/usr/local/google-cloud-sdk/bin:/usr/local/bin/argocd:/usr/local/bin/terraform:${GOBIN}

RUN chmod +x /usr/local/bin/bitrise \
    && bitrise setup \
    && bitrise envman -version \
    && bitrise stepman -version \
    #  cache for the StepLib
    && bitrise stepman setup -c https://github.com/bitrise-io/bitrise-steplib.git \
    && bitrise stepman update \
    && mkdir -p $BITRISE_SOURCE_DIR

WORKDIR $BITRISE_SOURCE_DIR

