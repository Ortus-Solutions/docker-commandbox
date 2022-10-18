#!/bin/bash
# Set any error to exit non-zero
set -e
# Perform reset operations now, before we start issuing exit codes

# Clear out any previous runtime JSON files
rm -f $APP_DIR/*.json

# Clear out any previous runtime-created modules
rm -rf $APP_DIR/modules

cd ${APP_DIR}

export USER=runtimeuser
export USER_ID=1002

echo "Starting server with Runtime user set to ${USER}"

runOutput="$( ${BUILD_DIR}/run.sh )"

printf "${runOutput}\n"

$BUILD_DIR/tests/test.up.sh

if [[ ${runOutput} != *"Configuration set to non-root user"* ]];then
	echo "Environment variable USER was not applied at runtime"
	exit 1
fi

# cleanup
unset USER
unset USER_ID
box server stop