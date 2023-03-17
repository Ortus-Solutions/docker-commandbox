#!/bin/bash
# Set any error to exit non-zero
set -e
# Perform reset operations now, before we start issuing exit codes

# Clear out any previous runtime JSON files
rm -f $APP_DIR/*.json

# Clear out any previous runtime-created modules
rm -rf $APP_DIR/modules

mkdir -p $APP_DIR/webroot

export BOX_SERVER_WEB_WEBROOT=./webroot

runOutput="$( ${BUILD_DIR}/run.sh )"

printf '%s\n' "${runOutput}"

cd ${APP_DIR}

SERVER_STATUS=$( box server status )

echo $SERVER_STATUS

if [[ ! $SERVER_STATUS ]] || [[ ${SERVER_STATUS} != *"running"* ]];then
	echo "The CFML server returned a status of stopped."
	echo "The log output of the server was:"
	echo $( box server log )
	exit 1
fi

box server stop

# Clean up
rm -f $APP_DIR/*.json
rm -rf $APP_DIR/modules
rm -rf $APP_DIR/modules
unset BOX_SERVER_WEB_WEBROOT