#!/bin/bash
set -e

DEBUG_FLAG=false
DRY_RUN_FLAG=true
SCRIPT_TYPE=bash

if [[ $IMAGE_TESTING_IN_PROGRESS ]]; then
    DRY_RUN_FLAG=false
    SCRIPT_TYPE=
else
    echo "INFO: Generating server startup script"
fi

# Attempt to run CFPM before the server start if warming up or testing
if [[ !$DRY_RUN_FLAG ]]; then
    $BUILD_DIR/util/adobe-cfpm.sh
fi

box server start \
    trayEnable=false \
    host=0.0.0.0 \
    openbrowser=false \
    port=${PORT} \
    sslPort=${SSL_PORT} \
    saveSettings=false  \
    dryRun=${DRY_RUN_FLAG} \
    console=${DRY_RUN_FLAG} \
    startScript=${SCRIPT_TYPE} \
    verbose=true

# Adobe 2021 package manager installs after the server files are in place
if [[ $DRY_RUN_FLAG ]]; then
    $BUILD_DIR/util/adobe-cfpm.sh
fi

# If not testing then the script was generated and we run it directly, bypassing the CommandBox wrapper
if [[ ! $IMAGE_TESTING_IN_PROGRESS ]]; then

    if [[ ! $FINALIZE_STARTUP ]]; then

        echo "INFO: Starting server using generated script: ${BIN_DIR}/startup.sh"

        mv $APP_DIR/server-start.sh $BIN_DIR/startup.sh

        chmod +x $BIN_DIR/startup.sh

        $BIN_DIR/startup.sh

    else

        echo "INFO: Seeding finalized server startup script to ${BIN_DIR}/startup-final.sh"

        # If our image is being finalized, then we move the script to the terminal script location, which bypasses re-evaluation
        mv $APP_DIR/server-start.sh $BIN_DIR/startup-final.sh

        chmod +x $BIN_DIR/startup-final.sh

    fi

fi
