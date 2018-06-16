#!/bin/bash

# Installs the latest CommandBox Binary
curl --location 'https://www.ortussolutions.com/parent/download/commandbox/type/bin' -o /tmp/box.zip

unzip /tmp/box.zip -d ${BIN_DIR} && chmod +x ${BIN_DIR}/box
echo "$(box version) successfully installed"

# Swap out the full lucee jar with a slimmed down version without modules to reduce our size
rm -rf /root/.CommandBox/lib/lucee-*.jar
# We have to hard-code our lucee download version until a generic download link is provided
# We name it without the version so that the warmed up Lucee server will download a completely new version with the extensions
curl --location 'http://cdn.lucee.org/lucee-light-5.2.7.63.jar' -o /root/.CommandBox/lib/lucee-light.jar