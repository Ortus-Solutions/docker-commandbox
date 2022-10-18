#!/bin/bash

# Clear out any previous runtime JSON files
rm -f $APP_DIR/*.json

# Clear out any previous runtime-created modules
rm -rf $APP_DIR/modules

# Clear out our previous server directory
rm -rf $LIB_DIR/serverHome

cd ${APP_DIR}

export BOX_SERVER_APP_CFENGINE=adobe@2021
export CFPM_INSTALL=mail,image

echo "Starting Adobe 2021 server with CFPM_INSTALL environment variable set"

runOutput="$( ${BUILD_DIR}/run.sh )"

printf "${runOutput}\n"

$BUILD_DIR/tests/test.up.sh

if [[ ${runOutput} != *"Coldfusion Package Manager Installation initiated"* ]];then
	echo "CFPM_INSTALL environment variable was not applied"
	exit 1
fi

# cleanup
unset BOX_SERVER_APP_CFENGINE
unset CFPM_INSTALL
box server stop
rm -rf $LIB_DIR/serverHome