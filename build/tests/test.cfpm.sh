#!/bin/bash
# Set any error to exit non-zero
set -e

# Clear out any previous runtime JSON files
rm -f $APP_DIR/*.json

# Clear out any previous runtime-created modules
rm -rf $APP_DIR/modules

cd ${APP_DIR}
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
unset CFPM_INSTALL
box server stop
