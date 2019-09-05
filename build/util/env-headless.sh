echo "****************************************************************"
echo "INFO: Headless startup flag detected, disabling admin web interfaces..."

#ACF Lockdown
export cfconfig_adminAllowedIPList=$(hostname -I)
export cfconfig_debuggingIPList=$(hostname -I)

echo "INFO: ACF administrative access restricted to ${cfconfig_adminAllowedIPList}"

if [[ -f $APP_DIR/server.json ]]; then
	REWRITE_CONFIG=$(cat server.json | jq -r '.web.rewrites.config')
fi

if [[ ! $REWRITE_CONFIG ]] || [[ $REWRITE_CONFIG = 'null' ]]; then

	echo "INFO: Applying headless configuration via rewrite rules"

	box server set web.rewrites.enable=true web.rewrites.config=$BUILD_DIR/util/urlrewrite-headless.xml

else

	echo "WARN: Existing rewrite configuration detected.  Could not apply headless configuration."

fi

echo "INFO: Server admininistrative web interfaces are now disallowed"

echo "****************************************************************"