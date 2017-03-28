#!/bin/bash

if [[ ! $PORT ]] || [[ $PORT == 'null' ]]; then
	echo "No defined port available"
	exit 1
fi

cd ${APP_DIR}

SERVER_STATUS=$( box server status )

if [[ ! $SERVER_STATUS ]] || [[ ${SERVER_STATUS} != *"running"* ]];then
	echo "Server exited and was not running"
	exit 1
fi