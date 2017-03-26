#!/bin/bash
cd $APP_DIR

# Check for a defined server home directory in box.json
if [[ -f server.json ]]; then
	SERVER_HOME_DIRECTORY=$(cat server.json | jq -r '.app.serverHomeDirectory')
	CFENGINE=$(cat server.json | jq -r '.app.cfengine')

	# ensure our string nulls are true nulls
	if [[ $SERVER_HOME_DIRECTORY == 'null' ]]; then
		unset $SERVER_HOME_DIRECTORY
	else
		echo "Server Home Directory defined in server.json as: ${SERVER_HOME_DIRECTORY}"
	fi

	if [[ $CFENGINE == 'null' ]]; then
		unset $CFENGINE
	else
		echo "CF Engine defined as ${CFENGINE}"
	fi

fi

# Default values for engine and home directory - so we can use cfconfig 
SERVER_HOME_DIRECTORY="${SERVER_HOME_DIRECTORY:=${HOME}/serverHome}"
CFENGINE="${CFENGINE:=lucee@4.5}"
FULL_VERSION=${CFENGINE#*@*}
ENGINE_VERSION=${FULL_VERSION%%.*}
ENGINE_VENDOR=${CFENGINE%%@*}

echo "Server Home Directory set to: ${SERVER_HOME_DIRECTORY}"
echo "CF Engine set to ${CFENGINE}"
echo "Engine vendor: ${ENGINE_VENDOR}"
echo "Engine version: ${ENGINE_VERSION}"

#Lucee has a different syntax than ACF, since there are two passwords
if [[ $ENGINE_VENDOR == 'lucee' ]]; then
	# Custom format name required by cfconfig ( JIRA:CFCONFIG-1 )
	CFCONFIG_FORMAT="${ENGINE_VENDOR}Server@${ENGINE_VERSION}"
	WEB_CONFIG_FORMAT="${ENGINE_VENDOR}Web@${ENGINE_VERSION}"
	LUCEE_WEB_HOME="${LUCEE_WEB_HOME:-${SERVER_HOME_DIRECTORY}/WEB-INF/lucee-web}"
	echo "Lucee web home set to: ${LUCEE_WEB_HOME}"
	LUCEE_SERVER_HOME="${LUCEE_SERVER_HOME:-${SERVER_HOME_DIRECTORY}/WEB-INF/lucee-server}" 
	echo "Lucee server home set to: ${LUCEE_SERVER_HOME}"
else
	CFCONFIG_FORMAT="${ENGINE_VENDOR}@${ENGINE_VERSION}"
fi
			

#Check for cfconfig specific environment variables
while IFS='=' read -r name value ; do
	if [[ $name == *'cfconfig_'* ]]; then
		prefix=${name%%_*}
		settingName=${name#*_}

		#if our setting is for the admin password, flag it as set
		if [[ $settingName == 'adminPassword' ]]; then
			ADMIN_PASSWORD_SET=true
		fi

		echo "Setting cfconfig variable ${settingName}"
		
		if [[ $ENGINE_VENDOR == 'lucee' ]]; then

			box cfconfig set ${settingName}=${value} to=${LUCEE_SERVER_HOME} toFormat=${CFCONFIG_FORMAT} >> /dev/null
			box cfconfig set ${settingName}=${value} to=${LUCEE_WEB_HOME} toFormat=${WEB_CONFIG_FORMAT} >> /dev/null
		
		else
		
			box cfconfig set ${settingName}=${value} to=${SERVER_HOME_DIRECTORY} toFormat=${CFCONFIG_FORMAT} >> /dev/null
		
		fi
	fi
done < <(env)

# Convention environment variable for CFConfig file
if [[ $CFCONFIG ]] && [[ -f $CFCONFIG ]]; then
	echo "Engine configuration file detected at ${CFCONFIG}"

	#if our admin password is provided, flag it as set
	ADMIN_PASSWORD_SET="$(cat ${CFCONFIG} | jq -r '.adminPassword')"

	if [[ $ENGINE_VENDOR == 'lucee' ]]; then
	
		box cfconfig import from=${CFCONFIG} to=${SERVER_HOME_DIRECTORY}/WEB-INF/lucee-server toFormat=${CFCONFIG_FORMAT}
		
		# if our admin password is set, set the web context password as well
		if [[ $ADMIN_PASSWORD_SET ]]; then
			box cfconfig set adminPassword=${ADMIN_PASSWORD_SET} to=${SERVER_HOME_DIRECTORY}/WEB-INF/lucee-web toFormat=${WEB_CONFIG_FORMAT} >> /dev/null
		fi

	else
	
		box cfconfig import from=${CFCONFIG} to=${SERVER_HOME_DIRECTORY} toFormat=${CFCONFIG_FORMAT}
	
	fi

fi

# If our admin password was not provided send a warning. 
# We can't set it, because a custom server home may be provided
if [[ ! $ADMIN_PASSWORD_SET ]]; then

	echo "No admin password was provided in the environment variables.  If you do not have a custom server home directory in your app, your server is insecure!"

fi

# We need to do this all on one line because escaped line breaks 
# aren't picked up correctly by CommandBox on this base image ( JIRA:COMMANDBOX-598 )
box server set app.serverHomeDirectory=${SERVER_HOME_DIRECTORY} web.host=0.0.0.0 openbrowser=false web.http.port=${PORT} web.ssl.port=${SSL_PORT}
box server start

#Sleep for ACF servers
sleep 10
tail -f $( echo $(box server info property=consoleLogPath) | xargs )