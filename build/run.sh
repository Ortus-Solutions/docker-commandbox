#!/bin/bash
set -e

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

	box config set verboseErrors=true

	# If a custom user is requested set it before we begin
	if [[ $USER ]] && [[ $USER != $(whoami) ]]; then
		echo "INFO: Configuration set to non-root user: ${USER}"
		export HOME=/home/$USER
			
		if [[ -f /etc/alpine-release ]]; then
			# If the user exists then we skip the directory migrations as the container is in restart
			if ! id -u $USER > /dev/null 2>&1; then
				adduser $USER --home $HOME --disabled-password --ingroup $WORKGROUP
			fi

		else
			# If the user exists then we skip the directory migrations as the container is in restart
			if ! id -u $USER > /dev/null 2>&1; then
				useradd $USER 
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
		

		if [ $SERVER_HOME_DIRECTORY ]; then
			chown -R $USER $SERVER_HOME_DIRECTORY
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

		# Check for a defined server home directory in box.json
		if [[ -f server.json ]]; then

			if [[ ! $SERVER_HOME_DIRECTORY ]]; then	
				SERVER_HOME_DIRECTORY=$(cat server.json | jq -r '.app.serverHomeDirectory')
			fi

			if [[ ! $CFENGINE ]]; then	
				CFENGINE=$(cat server.json | jq -r '.app.cfengine')
			fi

			# ensure our string nulls are true nulls
			if [[ ! $SERVER_HOME_DIRECTORY ]] ||  [[ $SERVER_HOME_DIRECTORY = 'null' ]] ; then
				SERVER_HOME_DIRECTORY=''
			else
				echo "INFO: Server Home Directory defined in server.json as: ${SERVER_HOME_DIRECTORY}"
				#Assume our admin password has been set if we are including a custom server home
				if [[ ${SERVER_HOME_DIRECTORY} != "${LIB_DIR}/serverHome" ]]; then
					ADMIN_PASSWORD_SET=true
				fi
			fi

			# Nullify if we have a string null returned by jq
			if [[ $CFENGINE = 'null' ]]; then
				unset CFENGINE
			else
				echo "INFO: CF Engine defined as ${CFENGINE}"
			fi

		fi

		# Default values for engine and home directory - so we can use cfconfig 
		export SERVER_HOME_DIRECTORY="${SERVER_HOME_DIRECTORY:=${LIB_DIR}/serverHome}"

		if  [[ !$cfconfigfile ]] && [[ -f .cfconfig.json ]]; then
			export cfconfigfile=$APP_DIR/.cfconfig.json
			echo "INFO: Convention .cfconfig.json found at $APP_DIR/.cfconfig.json"	
		fi

		echo "INFO: Server Home Directory set to: ${SERVER_HOME_DIRECTORY}"		

		#Check for cfconfig specific environment variables - the CommandBox binary will handle these on start
		while IFS='=' read -r name value ; do
			if [[ $name == *'cfconfig_'* ]]; then
				settingName=${name//cfconfig_}
				#if our setting is for the admin password, flag it as set
				if [[ " ${CFCONFIG_PASSWORD_KEYS[@]} " =~ " ${settingName} " ]]; then
					ADMIN_PASSWORD_SET=true
				fi
			fi
		done < <(env)

		if [[ $CFCONFIG ]] && [[ -f $CFCONFIG ]]; then
			export cfconfigfile=$CFCONFIG
		fi

		# Convention environment variable for CFConfig file
		if [[ $cfconfigfile ]] && [[ -f $cfconfigfile ]]; then
			echo "INFO: Engine configuration file detected at ${cfconfigfile}"

			#if our admin password is provided, flag it as set
			for pwKey in "${CFCONFIG_PASSWORD_KEYS[@]}"
			do
				if [[ $( key=".${pwKey}"; cat ${cfconfigfile} | jq -r "${key}") != 'null' ]]; then
					ADMIN_PASSWORD_SET=true
					break
				fi
			done

		fi

		#Check for a previously set password
		if [[ -f ${HOME}/.enginePwd ]]; then
			echo "INFO: A previous random password was generated for the server administration. Marking as set."
			ADMIN_PASSWORD_SET=true
		fi


		if [[ $ADMIN_PASSWORD_SET != true ]]; then
			if [[ ${SERVER_HOME_DIRECTORY} == "${LIB_DIR}/serverHome" ]]; then
				#Generate a random password
				openssl rand -base64 64 | tr -d '\n\/\+=' > ${HOME}/.enginePwd
				export cfconfig_adminPassword=`cat ${HOME}/.enginePwd`
				export cfconfig_adminPasswordDefault=`cat ${HOME}/.enginePwd`
				export cfconfig_adminRDSPassword=`cat ${HOME}/.enginePwd`
				export cfconfig_ACF11RDSPassword=`cat ${HOME}/.enginePwd`
				echo "WARN: Configuration did not detect any known mechanisms for changing the default password.  Your CF engine administrative password has been set to:"
				echo `cat ${HOME}/.enginePwd`
				# Keep this file so that restarts can test for its existence - unless we are testing or building 
				if $IMAGE_TESTING_IN_PROGRESS; then
					rm -f ${HOME}/.enginePwd
				fi
			else
				# If we still don't have an admin password flag up, send a warning. 
				# We can't set it, because a custom server home may be provided
				echo "WARN: No admin password was provided in the environment variables or you have specified a custom server home directory.  If you have not explicitly set the password, your server is insecure!"
			fi
		fi

		# If box install flag is up, do installation
		if [[ $BOX_INSTALL ]] || [[ $box_install ]]; then
			box install
		fi

		# Server startup
		$BUILD_DIR/util/start-server.sh

	fi


fi
