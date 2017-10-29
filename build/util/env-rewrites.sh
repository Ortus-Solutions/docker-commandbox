echo "****************************************************************"
echo "INFO: Rewrite Flag detected, updating configuration..."

	if [[ -f $APP_DIR/server.json ]]; then
		REWRITE_ENABLED=$(cat server.json | jq -r '.web.rewrites.enable')
	fi
	
	if [[ ! $REWRITE_ENABLED ]] || [[ $REWRITE_ENABLED = 'null' ]]; then

		box server set web.rewrites.enable=true

	else

		echo "INFO: Existing explict rewrite configuration detected in server.json. Environmental flags will be ignored."

	fi

echo "****************************************************************"