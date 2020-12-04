#!/usr/bin/env bash

# download CLI
curl -sSL https://github.com/bitrise-io/bitrise/releases/download/${CLI_VERSION}/bitrise-$(uname -s)-$(uname -m) -o /usr/local/bin/bitrise

# assign executable ownership
chmod +x /usr/local/bin/bitrise