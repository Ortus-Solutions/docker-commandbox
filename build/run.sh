#!/bin/bash
set -e
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

	# Removing support for this parsing temporarily due to environment variables not being able to parsed accurately
	# if [[ ! $HEAP_SIZE ]]; then	
	# 	HEAP_SIZE=$(cat server.json | jq -r '.jvm.heapSize')
	# fi

	# ensure our string nulls are true nulls
	if [[ ! $SERVER_HOME_DIRECTORY ]] ||  [[ $SERVER_HOME_DIRECTORY = 'null' ]] ; then
		SERVER_HOME_DIRECTORY=''
	else
		echo "INFO: Server Home Directory defined in server.json as: ${SERVER_HOME_DIRECTORY}"
		#Assume our admin password has been set if we are including a custom server home
		if [[ ${SERVER_HOME_DIRECTORY} != "${HOME}/serverHome" ]]; then
			ADMIN_PASSWORD_SET=true
		fi
	fi

	if [[ $CFENGINE = 'null' ]] || [[ ! $CFENGINE ]]; then
		CFENGINE=''
	else
		echo "INFO: CF Engine defined as ${CFENGINE}"
	fi

fi

# Default values for engine and home directory - so we can use cfconfig 
export SERVER_HOME_DIRECTORY="${SERVER_HOME_DIRECTORY:=${HOME}/serverHome}"
export CFENGINE="${CFENGINE:=lucee@5}"

# Default Heap Size which matches the CommandBox default
# export HEAP_SIZE="${HEAP_SIZE:=512}"
# echo "INFO: The JVM heap size for this container is set to ${HEAP_SIZE}"

echo "INFO: Server Home Directory set to: ${SERVER_HOME_DIRECTORY}"
echo "INFO: CF Engine set to ${CFENGINE}"			

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
	if [[ ${SERVER_HOME_DIRECTORY} == "${HOME}/serverHome" ]]; then
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

# If the headless flag is up, remove our administrative interfaces
if [[ $HEADLESS ]] || [[ $headless ]]; then
	$BUILD_DIR/util/env-headless.sh
fi

# If Server URL Rewrites are set, then activate it 
if [[ $URL_REWRITES ]] || [[ $url_rewrites ]]; then
	$BUILD_DIR/util/env-rewrites.sh
fi

# Server startup
$BUILD_DIR/util/start-server.sh

# Sleep until server is ready for traffic
echo "INFO: Waiting for server to become available..."
	while [ ! -f "${SERVER_HOME_DIRECTORY}/logs/server.out.txt" ] ; do sleep 2; done
echo "INFO: Server engine up and running."

echo "INFO: Configuration processed and server started in ${SECONDS} seconds."

# Skip our tail output when running our tests - flag for 500 lines so we can see our context creation
if [[ ! $IMAGE_TESTING_IN_PROGRESS ]]; then
	tail -n 500 -f $( echo $(box server info property=consoleLogPath) | xargs )
fi
