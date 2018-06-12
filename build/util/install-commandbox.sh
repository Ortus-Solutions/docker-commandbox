#!/bin/bash

# Installs the latest CommandBox Binary

# Stable is commented out for now
curl --location 'https://www.ortussolutions.com/parent/download/commandbox-be/type/bin' -o /tmp/box.zip

# Using snapshot to ensure character encoding fix
# curl --location 'http://integration.stg.ortussolutions.com/artifacts/ortussolutions/commandbox/4.0.0-SNAPSHOT/commandbox-bin-4.0.0-SNAPSHOT.zip' -o /tmp/box.zip
unzip /tmp/box.zip -d ${BIN_DIR} && chmod +x ${BIN_DIR}/box
echo "$(box version) successfully installed"