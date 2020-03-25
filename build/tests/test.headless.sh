#!/bin/bash
# Perform reset operations now, before we start issuing exit codes

# Clear out any previous runtime JSON files
rm -f $APP_DIR/*.json

# Clear out any previous runtime-created modules
rm -rf $APP_DIR/modules

cd ${APP_DIR}

export HEADLESS=true

echo "Starting server with headless variable set"

runOutput="$( ${BUILD_DIR}/run.sh )"

printf "${runOutput}\n"

$BUILD_DIR/tests/test.up.sh

if [[ ${runOutput} != *"Headless startup flag detected"* ]];then
	echo "Headless environment variable was not detected or set"
	exit 1
fi

# cleanup
unset HEADLESS
box server stop