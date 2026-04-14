#!/bin/bash
set -e

DEBUG_FLAG=false
DRY_RUN_FLAG=true
SCRIPT_TYPE=bash

if [[ $IMAGE_TESTING_IN_PROGRESS ]]; then
    DRY_RUN_FLAG=false
    SCRIPT_TYPE=
else
    logMessage "INFO" "Generating server startup script"
fi

# Attempt to run CFPM before the server start if warming up or testing
if [[ $DRY_RUN_FLAG == "false" ]]; then
    . $BUILD_DIR/util/adobe-cfpm.sh
fi

# Check if server.json has any listen bindings defined or SKIP_PORT_ASSIGNMENTS is true - if so we skip port settings
DEFINED_SERVERCONFIGFILE=${BOX_SERVER_SERVERCONFIGFILE:=server.json}
SKIP_PORTS=false

if [[ "${SKIP_PORT_ASSIGNMENTS}" == "true" ]]; then
    SKIP_PORTS=true
    logMessage "INFO" "SKIP_PORT_ASSIGNMENTS=true, skipping port and sslPort settings"
elif [[ -f "${DEFINED_SERVERCONFIGFILE}" ]] && [[ "$(jq 'any(.sites[]?; .bindings[]?.listen)' "${DEFINED_SERVERCONFIGFILE}")" == "true" ]]; then
    SKIP_PORTS=true
    logMessage "INFO" "Detected custom multi-site listen bindings in ${DEFINED_SERVERCONFIGFILE}, skipping port and sslPort settings"
fi

if [[ "${SKIP_PORTS}" == "true" ]]; then
	logMessage "INFO" "$( box server start \
		trayEnable=false \
		host=0.0.0.0 \
		openbrowser=false \
		saveSettings=false  \
		dryRun=${DRY_RUN_FLAG} \
		console=${DRY_RUN_FLAG} \
		startScript=${SCRIPT_TYPE} \
		startScriptFile=${APP_DIR}/server-start.sh \
		verbose=true )"
else
	logMessage "INFO" "$( box server start \
		trayEnable=false \
		host=0.0.0.0 \
		openbrowser=false \
		port=${PORT} \
		sslPort=${SSL_PORT} \
		saveSettings=false  \
		dryRun=${DRY_RUN_FLAG} \
		console=${DRY_RUN_FLAG} \
		startScript=${SCRIPT_TYPE} \
		startScriptFile=${APP_DIR}/server-start.sh \
		verbose=true )"
fi

# Adobe 2021 package manager installs after the server files are in place
if [[ $DRY_RUN_FLAG == "true" ]]; then
    . $BUILD_DIR/util/adobe-cfpm.sh
fi

# If not testing then the script was generated and we run it directly, bypassing the CommandBox wrapper
if [[ ! $IMAGE_TESTING_IN_PROGRESS ]]; then

    if [[ ! $FINALIZE_STARTUP ]]; then

        logMessage "INFO" "Starting server using generated script: ${BIN_DIR}/startup.sh"

        mv $APP_DIR/server-start.sh $BIN_DIR/startup.sh

        chmod +x $BIN_DIR/startup.sh

        . $BIN_DIR/startup.sh

    else

        logMessage "INFO" "Seeding finalized server startup script to ${BIN_DIR}/startup-final.sh"

        # If our image is being finalized, then we move the script to the terminal script location, which bypasses re-evaluation
        mv $APP_DIR/server-start.sh $BIN_DIR/startup-final.sh

        chmod +x $BIN_DIR/startup-final.sh

    fi

fi
