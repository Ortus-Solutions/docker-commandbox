#!/bin/bash

# Make sure errors (like curl failing, or unzip failing, or anything failing) fails the build
set -ex

if [ -z "$COMMANDBOX_VERSION" ]; then
  echo "CommandBox Version not supplied via variable COMMANDBOX_VERSION"
  exit 1
fi

# Installs the latest CommandBox Binary. We can use the thin client as it will download all of its dependencies on first run.
curl https://downloads.ortussolutions.com/ortussolutions/commandbox/${COMMANDBOX_VERSION}/box-thin -o ${BIN_DIR}/box
chmod 755 ${BIN_DIR}/box

echo "$(box version) successfully installed"

box uninstall --system commandbox-update-check

# Set container in to single server mode
box config set server.singleServerMode=true

# Set our log pattern to be ISO with timezone info, as containers might be running in different zones
box config set server.defaults.runwar.console.appenderLayoutOptions.pattern="[%p] %d{yyyy-MM-dd\'T\'HH:mm:ssXXX} %c - %m%n"

$BUILD_DIR/util/optimize.sh
