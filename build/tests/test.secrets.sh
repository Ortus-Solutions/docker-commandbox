#!/bin/bash

echo "Testing the docker secret expansion"

export ENV_SECRETS_DEBUG=true

runOutput="$( ${BUILD_DIR}/run.sh )"

printf "Server Output:\n\n ${runOutput}"

${BUILD_DIR}/tests/test.up.sh

if [[ ${runOutput} != *"Expanded variable"* ]];then
	echo "Environmental secrets were not detected or expanded"
	exit 1
fi

# cleanup
unset ENV_SECRETS_DEBUG
cd $APP_DIR
box server stop
