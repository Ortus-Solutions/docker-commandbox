#!/bin/bash

#Install apt dependencies
echo "Installing System Libraries"
apt-get update
apt-get install --assume-yes git jq

# Install commandbox binaries
echo "Installing CommandBox"
curl --location 'https://www.ortussolutions.com/parent/download/commandbox/type/bin' -o /tmp/box.zip
unzip /tmp/box.zip -d ${BIN_DIR}
chmod +x ${BIN_DIR}/box
COMMANDBOX_VERSION="$(box version)"
echo "$COMMANDBOX_VERSION successfully installed"

echo "Installing cfconfig module"
echo $(box install commandbox-cfconfig)

cd $BUILD_DIR