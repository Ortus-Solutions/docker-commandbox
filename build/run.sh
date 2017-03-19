#!/bin/bash
cd $APP_DIR
box server set \
	web.host=0.0.0.0 \
	openbrowser=false \
	web.http.port=${PORT} \
	web.ssl.port=${SSL_PORT} 
box server start
#Sleep for ACF servers
sleep 10
tail -f $( echo $(box server info property=consoleLogPath) | xargs )