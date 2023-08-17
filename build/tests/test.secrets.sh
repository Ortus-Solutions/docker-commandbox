#!/bin/bash
# Set any error to exit non-zero
set -e

echo "Testing the docker secret expansion"

export ENV_SECRETS_DEBUG=true

echo "bar" > /tmp/foo

export FOO_FILE=/tmp/foo

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

if [[ ${runOutput} != *"Expanded variable"* ]];then
	echo "Environmental secrets were not detected or expanded"
	exit 1
fi

if [[ ${runOutput} != *"Expanded variable: FOO=bar"* ]];then
	echo "_FILE convention-named secrets were not expanded"
	exit 1
fi

# cleanup
unset ENV_SECRETS_DEBUG
cd $APP_DIR
box server stop
