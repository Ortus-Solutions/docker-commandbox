#!/bin/bash

# Installs the latest CommandBox Binary
curl -k -location "https://downloads.ortussolutions.com.s3.amazonaws.com/ortussolutions/commandbox/${COMMANDBOX_VERSION}/commandbox-bin-${COMMANDBOX_VERSION}.zip" -o /tmp/box.zip

unzip /tmp/box.zip -d ${BIN_DIR} && chmod +x ${BIN_DIR}/box
echo "$(box version) successfully installed"
