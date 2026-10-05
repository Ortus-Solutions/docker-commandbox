#!/bin/bash
set -e
umask 0002

## Logger mixin
. $BUILD_DIR/util/log.sh

## Handle deprecated/changed environment variables
. $BUILD_DIR/util/compat-env.sh

# Handle secret expansion before any other environmental variables are processed
. $BUILD_DIR/util/env-secrets-expand.sh

cd "$APP_DIR"

configureServer () {
	export box_config_verboseErrors=true
	SECONDS=0

	# CFConfig Available Password Keys
	CFCONFIG_PASSWORD_KEYS=( "adminPassword" "adminPasswordDefault" "hspw" "pw" "defaultHspw" "defaultPw" "ACF11Password" )
	ADMIN_PASSWORD_SET=false

	# Check for a defined server home directory in server.json
	if [[ -f ${BOX_SERVER_SERVERCONFIGFILE:=server.json} ]]; then
		if [[ ! $BOX_SERVER_APP_SERVERHOMEDIRECTORY ]]; then
			BOX_SERVER_APP_SERVERHOMEDIRECTORY=$(jq -r '.app.serverHomeDirectory' "$BOX_SERVER_SERVERCONFIGFILE")
		fi
		if [[ ! $BOX_SERVER_APP_CFENGINE ]]; then
			BOX_SERVER_APP_CFENGINE=$(jq -r '.app.cfengine' "$BOX_SERVER_SERVERCONFIGFILE")
		fi
		if [[ ! $BOX_SERVER_APP_SERVERHOMEDIRECTORY ]] || [[ $BOX_SERVER_APP_SERVERHOMEDIRECTORY = 'null' ]]; then
			unset BOX_SERVER_APP_SERVERHOMEDIRECTORY
		else
			logMessage "INFO" "Server Home Directory defined in ${BOX_SERVER_SERVERCONFIGFILE} as: ${BOX_SERVER_APP_SERVERHOMEDIRECTORY}"
			#Assume our admin password has been set if we are including a custom server home
			if [[ $BOX_SERVER_APP_SERVERHOMEDIRECTORY != "${LIB_DIR}/serverHome" ]]; then
				ADMIN_PASSWORD_SET=true
			fi
		fi
		if [[ $BOX_SERVER_APP_CFENGINE = 'null' ]]; then
			unset BOX_SERVER_APP_CFENGINE
		else
			export BOX_SERVER_APP_CFENGINE
			logMessage "INFO" "CF Engine defined as ${BOX_SERVER_APP_CFENGINE}"
		fi
	fi

	# Default values for engine and home directory - so we can use cfconfig
	export BOX_SERVER_APP_SERVERHOMEDIRECTORY="${BOX_SERVER_APP_SERVERHOMEDIRECTORY:=${LIB_DIR}/serverHome}"
	if [[ ! $BOX_SERVER_CFCONFIGFILE ]] && [[ -f .cfconfig.json ]]; then
		logMessage "INFO" "Convention .cfconfig.json found at $APP_DIR/.cfconfig.json"
	fi
	logMessage "INFO" "Server Home Directory set to: ${BOX_SERVER_APP_SERVERHOMEDIRECTORY}"
}

# If we have a finalized startup script bypass all further evaluation and use it authoritatively
if [[ -f $STARTUP_DIR/startup-final.sh ]]; then
	if [[ -f $STARTUP_DIR/startup-final.env ]]; then
		. "$STARTUP_DIR/startup-final.env"
	fi
	export BOX_SERVER_APP_SERVERHOMEDIRECTORY="${BOX_SERVER_APP_SERVERHOMEDIRECTORY:=${LIB_DIR}/serverHome}"
else
	configureServer
fi

for runtimePath in "$HOME" "$APP_DIR" "$COMMANDBOX_HOME" "$BOXLANG_HOME" "$STARTUP_DIR" "$BOX_SERVER_APP_SERVERHOMEDIRECTORY"; do
	if ! mkdir -p "$runtimePath" || [[ ! -w $runtimePath || ! -x $runtimePath ]]; then
		logMessage 'ERROR' "Runtime directory is not writable by UID $(id -u): $runtimePath. Grant this UID or shared GID 1000 write access before starting the container."
		exit 1
	fi
done

if [[ -f $STARTUP_DIR/startup-final.sh ]]; then
	. "$STARTUP_DIR/startup-final.sh"
else
	# Remove any previous generated startup scripts so that the config is re-read
	rm -f "$STARTUP_DIR/startup.sh"

	# If box install flag is up, do installation
	if [[ $BOX_INSTALL ]] || [[ $box_install ]]; then
		box install
	fi

	# Server startup
	. "$BUILD_DIR/util/start-server.sh"
fi
