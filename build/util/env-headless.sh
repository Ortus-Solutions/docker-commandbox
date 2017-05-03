echo "****************************************************************"
echo "INFO: Headless startup flag detected, removing admin web interfaces..."

	if [[ -f $APP_DIR/server.json ]]; then
		REWRITE_CONFIG=$(cat server.json | jq -r '.web.rewrites.config')
	fi
	
	if [[ ! $REWRITE_CONFIG ]] || [[ $REWRITE_CONFIG = 'null' ]]; then

		echo "INFO: Applying headless configuration via rewrite rules for ${ENGINE_VENDOR} server"
	
		box server set web.rewrites.enable=true web.rewrites.config=$BUILD_DIR/util/urlrewrite-headless.xml

		echo "INFO: Server admininistrative web interfaces are now disallowed"

	else

		echo "WARN: Existing rewrite configuration detected.  Could not apply headless configuration."

	fi

echo "****************************************************************"