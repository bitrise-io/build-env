#!/usr/bin/env bash

GO_INSTALL=go$GO_VERSION.linux-amd64.tar.gz

# remove exinsting go
rm -rf /usr/local/go

# download new one
curl -sSL https://dl.google.com/go/$GO_INSTALL -o $GO_INSTALL

# extract it
tar -C /usr/local -xzf $GO_INSTALL

# version
/usr/local/go/bin/go version

# remove install file
rm $GO_INSTALL

# install additional dependencies
/usr/local/go/bin/go get -u github.com/kisielk/errcheck
/usr/local/go/bin/go get -u golang.org/x/lint/golint