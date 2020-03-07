#!/bin/bash
DEBUG_FLAG=false
DRY_RUN_FLAG=true
SCRIPT_TYPE=bash

if [[ $IMAGE_TESTING_IN_PROGRESS ]]; then
    DRY_RUN_FLAG=false
    SCRIPT_TYPE=
else
    echo "INFO: Generating server startup script"
fi

if [[ $DEBUG ]]; then
    DEBUG_FLAG=true
fi

if [[ $CFENGINE ]]; then
    box server start \
        cfengine=${CFENGINE} \
        serverHomeDirectory=${SERVER_HOME_DIRECTORY} \
        host=0.0.0.0 \
        openbrowser=false \
        port=${PORT} \
        sslPort=${SSL_PORT} \
        saveSettings=false  \
        debug=${DEBUG_FLAG} \
        dryRun=${DRY_RUN_FLAG} \
        console=${DRY_RUN_FLAG} \
        startScript=${SCRIPT_TYPE}
else
    box server start \
        serverHomeDirectory=${SERVER_HOME_DIRECTORY} \
        host=0.0.0.0 \
        openbrowser=false \
        port=${PORT} \
        sslPort=${SSL_PORT} \
        saveSettings=false  \
        debug=${DEBUG_FLAG} \
        dryRun=${DRY_RUN_FLAG} \
        console=${DRY_RUN_FLAG} \
        startScript=${SCRIPT_TYPE}
fi

# If not testing then the script was generated and we run it directly, bypassing the CommandBox wrapper
if [[ ! $IMAGE_TESTING_IN_PROGRESS ]]; then
    echo "INFO: Starting server using script at ${BIN_DIR}/startup.sh"

    # use exec so Java gets to be PID 1 - will be resolved in CommandBox 5.1
    sed -i 's/\/opt\/java/exec \/opt\/java/' ./server-start.sh
    
    mv ./server-start.sh $BIN_DIR/startup.sh

    chmod +x $BIN_DIR/startup.sh
    $BIN_DIR/startup.sh

fi
