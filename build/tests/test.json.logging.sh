#!/bin/bash
# Set any error to exit non-zero
set -e
# Perform reset operations now, before we start issuing exit codes

# Clear out any previous runtime JSON files
rm -f $APP_DIR/*.json

# Clear out any previous runtime-created modules
rm -rf $APP_DIR/modules

cd ${APP_DIR}

export BOX_SERVER_RUNWAR_CONSOLE_APPENDERLAYOUT="JSONTemplateLayout"

echo "Starting server with JSON logging enabled"

runOutput="$( ${BUILD_DIR}/run.sh )"

printf '%s\n' "${runOutput}"

$BUILD_DIR/tests/test.up.sh

if [[ ${runOutput} != *"\"level\": \"INFO\""* ]];then
	echo "JSON Template layout was not activated successfully"
	exit 1
fi

# cleanup
unset BOX_SERVER_RUNWAR_CONSOLE_APPENDERLAYOUT
box server stop