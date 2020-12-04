#!/bin/bash

FILE=terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# download
curl -sSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/$FILE -o $FILE
unzip $FILE

# move to PATH
mv terraform /usr/local/bin

# remove install
rm $FILE

# install tfsec
/usr/local/go/bin/go get -u github.com/tfsec/tfsec/cmd/tfsec