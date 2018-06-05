#!/bin/bash

# Installs the latest CommandBox Binary
curl --location 'https://www.ortussolutions.com/parent/download/commandbox/type/bin' -o /tmp/box.zip
unzip /tmp/box.zip -d ${BIN_DIR} && chmod +x ${BIN_DIR}/box
echo "$(box version) successfully installed"