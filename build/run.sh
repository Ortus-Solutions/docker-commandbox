#!/bin/bash
set -e

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
if [[ -f $BIN_DIR/startup-final.sh ]]; then
	if [[ -f $BIN_DIR/startup-final.env ]]; then
		. "$BIN_DIR/startup-final.env"
	fi
	export BOX_SERVER_APP_SERVERHOMEDIRECTORY="${BOX_SERVER_APP_SERVERHOMEDIRECTORY:=${LIB_DIR}/serverHome}"
else
	configureServer
fi

# If a custom user is requested set it before we begin
if [[ $USER ]] && [[ $USER != $(whoami) ]]; then
	logMessage 'INFO' "Configuration set to non-root user: ${USER}"
	export USER_ID=${USER_ID:-1001}
	export HOME=/home/$USER

	if ! id -u "$USER" > /dev/null 2>&1; then
		if [[ -f /etc/alpine-release ]]; then
			adduser "$USER" --uid "$USER_ID" --home "$HOME" --disabled-password --ingroup "$WORKGROUP"
		else
			useradd -u "$USER_ID" "$USER"
		fi
	fi
	usermod -a -G "$WORKGROUP" "$USER"
	mkdir -p "$HOME" "$COMMANDBOX_HOME" "$BOXLANG_HOME" "${BOXLANG_INSTALL_HOME:-$BOXLANG_HOME}" "$BOX_SERVER_APP_SERVERHOMEDIRECTORY"

	# Ensure permissions on relevant directories and any files created previously
	chown -R "$USER:$WORKGROUP" "$HOME" "$APP_DIR" "$BUILD_DIR" \
		"$COMMANDBOX_HOME" "$BOXLANG_HOME" "${BOXLANG_INSTALL_HOME:-$BOXLANG_HOME}" "$BOX_SERVER_APP_SERVERHOMEDIRECTORY"
	case "$BIN_DIR" in
		/bin|/sbin|/usr/bin|/usr/sbin|/usr/local/bin|/usr/local/sbin)
			logMessage 'ERROR' 'BIN_DIR must be an image-owned directory for custom-user startup, such as /opt/bin'
			exit 1
			;;
	esac
	chown -R "root:$WORKGROUP" "$BIN_DIR"
	chmod g+rwx "$BIN_DIR"

	printf -v userCommand 'export PATH=%q; exec %q' "$PATH" "$BUILD_DIR/run.sh"
	if [[ -f /etc/alpine-release ]]; then
		su -p -c "$userCommand" "$USER"
	else
		su --preserve-environment -c "$userCommand" "$USER"
	fi
	exit
fi

if [[ -f $BIN_DIR/startup-final.sh ]]; then
	. "$BIN_DIR/startup-final.sh"
else
	# Remove any previous generated startup scripts so that the config is re-read
	rm -f "$BIN_DIR/startup.sh"

	# If box install flag is up, do installation
	if [[ $BOX_INSTALL ]] || [[ $box_install ]]; then
		box install
	fi

	# Server startup
	. "$BUILD_DIR/util/start-server.sh"
fi
