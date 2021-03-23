#!/bin/sh

# Make sure errors (like curl failing, or unzip failing, or anything failing) fails the build
set -ex

echo "Commandbox version set to $COMMANDBOX_VERSION"

# if [ -z "$COMMANDBOX_VERSION" ]; then
#   echo "CommandBox Version not supplied via variable COMMANDBOX_VERSION"
#   exit 1
# fi

# Installs the latest CommandBox Binary
mkdir -p /tmp
curl -k  -o /tmp/box.zip -location "https://downloads.ortussolutions.com/ortussolutions/commandbox/${COMMANDBOX_VERSION}/commandbox-bin-${COMMANDBOX_VERSION}.zip"
unzip /tmp/box.zip -d ${BIN_DIR} && chmod 755 ${BIN_DIR}/box
echo "commandbox_home=${COMMANDBOX_HOME}" > ${BIN_DIR}/commandbox.properties

echo "$(box version) successfully installed"

# Set container in to single server mode
box config set server.singleServerMode=true

# Cleanup CommandBox modules which would not be necessary in a Container environment
SYSTEM_EXCLUDES=( "coldbox" "contentbox" "cachebox" "logbox" "games" "wirebox" )
MODULE_EXCLUDES=( "cfscriptme-command" "cb-module-template" )

for mod in "${SYSTEM_EXCLUDES[@]}"
do
	rm -rf ${COMMANDBOX_HOME}/cfml/system/modules_app/${mod}-commands
done

for mod in "${MODULE_EXCLUDES[@]}"
do
	rm -rf ${COMMANDBOX_HOME}/cfml/modules/${mod}
done

# Copy our more secure default rewrite config to the system config directory
rm -f ${COMMANDBOX_HOME}/cfml/system/config/urlrewrite.xml
cp $BUILD_DIR/resources/urlrewrite.xml ${COMMANDBOX_HOME}/cfml/system/config/urlrewrite.xml

$BUILD_DIR/util/optimize.sh
