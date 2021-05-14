#!/bin/bash

FILE="tfswitch-install.sh"
INSTALL_SCRIPT_COMMIT="2865ec9eb81fa8dc8cac1804d9c946999e1a785e"
MD5_CHECKSUM="db8a16f4fb9cd1e6cc728ac84754b0e7  $FILE"

# install tfswitch
curl -sSL https://raw.githubusercontent.com/warrensbox/terraform-switcher/$INSTALL_SCRIPT_COMMIT/install.sh -o $FILE

if [[ "$(md5sum $FILE)" != $MD5_CHECKSUM ]]; then
exit 1
fi

# make the script executable
chmod 755 $FILE

# install tfswitch
./$FILE -b /usr/local/bin


# remove old and install new terraform
rm /usr/local/bin/terraform
tfswitch $TERRAFORM_VERSION

# remove installer script
rm $FILE