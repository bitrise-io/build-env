#!/bin/bash

FILE=terraform_${VERSION}_linux_amd64.zip

# download
curl -sSL https://releases.hashicorp.com/terraform/$VERSION/$FILE -o $FILE
unzip $FILE

# move to PATH
mv terraform /usr/local/bin

# remove install
rm $FILE