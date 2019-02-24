#!/bin/bash

# We need to do this all on one line because escaped line breaks 
# aren't picked up correctly by CommandBox on this base image ( JIRA:COMMANDBOX-598 )
if [[ $DEBUG ]]; then
    box server start cfengine=${CFENGINE} javaVersion=${javaVersion} serverHomeDirectory=${SERVER_HOME_DIRECTORY} host=0.0.0.0 openbrowser=false port=${PORT} sslPort=${SSL_PORT} saveSettings=false  --debug
else
    box server start cfengine=${CFENGINE} javaVersion=${javaVersion} serverHomeDirectory=${SERVER_HOME_DIRECTORY} host=0.0.0.0 openbrowser=false port=${PORT} sslPort=${SSL_PORT} saveSettings=false
fi