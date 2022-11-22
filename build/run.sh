#!/bin/bash
set -e

## Handle deprecated/changed environment variables
. $BUILD_DIR/util/compat-env.sh

# If we have a finalized startup script bypass all further evaluation and use it authoritatively
if [[ -f $BIN_DIR/startup-final.sh ]]; then

	. $BUILD_DIR/util/env-secrets-expand.sh
	if [[ $USER ]] && [[ $USER != $(whoami) ]]; then
		if [[ -f /etc/alpine-release ]]; then
			su -p -c $BIN_DIR/startup-final.sh $USER
		else 
			su --preserve-environment -c $BIN_DIR/startup-final.sh $USER
		fi
	else
		$BIN_DIR/startup-final.sh
	fi

else
	# Remove any previous generated startup scripts so that the config is re-read
	rm -f $BIN_DIR/startup.sh

    export box_config_verboseErrors=true

	# If a custom user is requested set it before we begin
	if [[ $USER ]] && [[ $USER != $(whoami) ]]; then
		echo "INFO: Configuration set to non-root user: ${USER}"
		if [[ ! $USER_ID ]]; then
			export USER_ID=1001
		fi
		export HOME=/home/$USER
			
		if [[ -f /etc/alpine-release ]]; then
			# If the user exists then we skip the directory migrations as the container is in restart
			if ! id -u $USER > /dev/null 2>&1; then
				adduser $USER --uid $USER_ID --home $HOME --disabled-password --ingroup $WORKGROUP
			fi

		else
			# If the user exists then we skip the directory migrations as the container is in restart
			if ! id -u $USER > /dev/null 2>&1; then
				useradd -u $USER_ID $USER 
				usermod -a -G $WORKGROUP $USER
				# Ensure our user home directory exists - we need to create it manually for Alpine builds
				mkdir -p $HOME
			fi
			
		fi

		# Ensure permissions on relevant directories and any files created previously
		chown -R $USER:$WORKGROUP $HOME
		chown -R $USER:$WORKGROUP $APP_DIR
		chown -R $USER:$WORKGROUP $BUILD_DIR
		chown -R $USER:$WORKGROUP $COMMANDBOX_HOME
		chown -R root:$WORKGROUP $BIN_DIR
		chmod g+wrx $BIN_DIR
		mkdir -p ${LIB_DIR}/serverHome
		chown -R $USER:$WORKGROUP ${LIB_DIR}/serverHome
		

		if [ $BOX_SERVER_APP_SERVERHOMEDIRECTORY ]; then
			chown -R $USER $BOX_SERVER_APP_SERVERHOMEDIRECTORY
		fi

		cd $APP_DIR


		if [[ -f /etc/alpine-release ]]; then
			su -p -c $BUILD_DIR/run.sh $USER
		else 
			su --preserve-environment -c $BUILD_DIR/run.sh $USER
		fi

	else

		cd $APP_DIR

		SECONDS=0

		# Handle secret expansion before any other environmental variables are processed
		. $BUILD_DIR/util/env-secrets-expand.sh

		# CFConfig Available Password Keys
		CFCONFIG_PASSWORD_KEYS=( "adminPassword" "adminPasswordDefault" "hspw" "pw" "defaultHspw" "defaultPw" "ACF11Password" )
		ADMIN_PASSWORD_SET=false

		# Check for a defined server home directory in server.json
		if [[ -f server.json ]]; then

			if [[ ! $BOX_SERVER_APP_SERVERHOMEDIRECTORY ]]; then	
				BOX_SERVER_APP_SERVERHOMEDIRECTORY=$(cat server.json | jq -r '.app.serverHomeDirectory')
			fi

			if [[ ! $BOX_SERVER_APP_CFENGINE ]]; then	
				BOX_SERVER_APP_CFENGINE=$(cat server.json | jq -r '.app.cfengine')
			fi

			# ensure our string nulls eliminate the variable
			if [[ ! $BOX_SERVER_APP_SERVERHOMEDIRECTORY ]] ||  [[ $BOX_SERVER_APP_SERVERHOMEDIRECTORY = 'null' ]] ; then
				unset BOX_SERVER_APP_SERVERHOMEDIRECTORY
			else
				echo "INFO: Server Home Directory defined in server.json as: ${BOX_SERVER_APP_SERVERHOMEDIRECTORY}"
				#Assume our admin password has been set if we are including a custom server home
				if [[ ${BOX_SERVER_APP_SERVERHOMEDIRECTORY} != "${LIB_DIR}/serverHome" ]]; then
					ADMIN_PASSWORD_SET=true
				fi
			fi

			# Nullify if we have a string null returned by jq
			if [[ $BOX_SERVER_APP_CFENGINE = 'null' ]]; then
				unset BOX_SERVER_APP_CFENGINE
			else
				echo "INFO: CF Engine defined as ${BOX_SERVER_APP_CFENGINE}"
			fi

		fi

		# Default values for engine and home directory - so we can use cfconfig 
		export BOX_SERVER_APP_SERVERHOMEDIRECTORY="${BOX_SERVER_APP_SERVERHOMEDIRECTORY:=${LIB_DIR}/serverHome}"

		if [[ !BOX_SERVER_CFCONFIGFILE ]] && [[ -f .cfconfig.json ]]; then
			echo "INFO: Convention .cfconfig.json found at $APP_DIR/.cfconfig.json"	
		fi

		echo "INFO: Server Home Directory set to: ${BOX_SERVER_APP_SERVERHOMEDIRECTORY}"	

		# If box install flag is up, do installation
		if [[ $BOX_INSTALL ]] || [[ $box_install ]]; then
			box install
		fi

		# Server startup
		$BUILD_DIR/util/start-server.sh

	fi


fi
