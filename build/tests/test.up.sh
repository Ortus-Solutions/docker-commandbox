#!/bin/bash
# Perform reset operations now, before we start issuing exit codes

# Clear out any previous runtime JSON files
rm -f $APP_DIR/*.json

# Clear out any previous runtime-created modules
rm -rf $APP_DIR/modules


if [[ ! $PORT ]] || [[ $PORT == 'null' ]]; then
	echo "The image did not have a defined PORT variable"
	exit 1
fi

cd ${APP_DIR}

SERVER_STATUS=$( box server status )

echo $SERVER_STATUS

if [[ ! $SERVER_STATUS ]] || [[ ${SERVER_STATUS} != *"running"* ]];then
	echo "The CFML server returned a status of stopped."
	echo "The log output of the server was:"
	echo $( box server log )
	exit 1
fi

# Clean up
rm -f $APP_DIR/*.json
rm -rf $APP_DIR/modules