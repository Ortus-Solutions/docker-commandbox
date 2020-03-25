#!/bin/bash
DEBUG_FLAG=false
DRY_RUN_FLAG=true
SCRIPT_TYPE=bash
REWRITES_FILE=$BUILD_DIR/resources/urlrewrite.xml

if [[ $URL_REWRITES ]]; then
    echo "INFO: URL Rewrite variable detected in the environment. Setting to ${URL_REWRITES}..."
    REWRITES_ENABLE=$URL_REWRITES
else
    # Default to the CommandBox default
    REWRITES_ENABLE=false
fi


if [[ $IMAGE_TESTING_IN_PROGRESS ]]; then
    DRY_RUN_FLAG=false
    SCRIPT_TYPE=
else
    echo "INFO: Generating server startup script"
fi

if [[ $DEBUG ]]; then
    DEBUG_FLAG=true
fi

if [[ -f $APP_DIR/server.json ]]; then
    REWRITE_FLAG=$(cat server.json | jq -r '.web.rewrites.enable')
    REWRITE_CONFIG=$(cat server.json | jq -r '.web.rewrites.config')

    if [[ $REWRITE_FLAG ]] && [[ $REWRITE_FLAG != 'null' ]]; then
        REWRITES_ENABLE=$REWRITE_FLAG
        echo "INFO: Existing rewrite flag detected: ${REWRITE_FLAG}"
    fi

    if [[ $REWRITE_CONFIG ]] && [[ $REWRITE_CONFIG != 'null' ]]; then
        REWRITES_FILE=$REWRITE_CONFIG
        echo "INFO: Existing rewrite configuration detected: ${REWRITE_CONFIG}"
    fi
fi

if [[ $HEADLESS ]] || [[ $headless ]]; then
    echo "****************************************************************"
    echo "INFO: Headless startup flag detected, disabling admin web interfaces..."

    #ACF Lockdown
    export cfconfig_adminAllowedIPList=127.0.0.1
    export cfconfig_debuggingIPList=127.0.0.1

    echo "INFO: ACF administrative access restricted to ${cfconfig_adminAllowedIPList}"

    if [[ ! $REWRITE_CONFIG ]] || [[ $REWRITE_CONFIG = 'null' ]]; then
        echo "INFO: Applying headless configuration via rewrite rules"
        REWRITES_ENABLE=true
        REWRITES_FILE=${BUILD_DIR}/resources/urlrewrite-headless.xml
        echo "INFO: Server admininistrative web interfaces are now disallowed"
    else
        REWRITES_FILE=$REWRITE_CONFIG
        echo "WARN: Existing rewrite configuration detected: ${REWRITE_CONFIG} .  Could not apply headless configuration."
    fi

    echo "****************************************************************"
fi

if [[ $CFENGINE ]]; then
    box server start \
        cfengine=${CFENGINE} \
        serverHomeDirectory=${SERVER_HOME_DIRECTORY} \
        rewritesEnable=${REWRITES_ENABLE} \
        rewritesConfig=${REWRITES_FILE} \
        trayEnable=false \
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
        rewritesEnable=${REWRITES_ENABLE} \
        rewritesConfig=${REWRITES_FILE} \
        trayEnable=false \
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

    if [[ ! $FINALIZE_STARTUP ]]; then

        echo "INFO: Starting server using genrated script: ${BIN_DIR}/startup.sh"

        mv ./server-start.sh $BIN_DIR/startup.sh

        chmod +x $BIN_DIR/startup.sh

        $BIN_DIR/startup.sh

    else

        echo "INFO: Seeding finalized server startup script to ${BIN_DIR}/startup-final.sh"

        # If our image is being finalized, then we move the script to the terminal script location, which bypasses re-evaluation
        mv ./server-start.sh $BIN_DIR/startup-final.sh

        chmod +x $BIN_DIR/startup-final.sh

    fi

fi
