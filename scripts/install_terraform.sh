#!/bin/bash

# install tfswitch
curl -sSL https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash

# install terraform
tfswitch $TERRAFORM_VERSION