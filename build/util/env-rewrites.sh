echo "****************************************************************"
echo "INFO: Rewrite Flag detected, updating configuration..."

	if [[ -f $APP_DIR/server.json ]]; then
		REWRITES_ENABLED=$(cat server.json | jq -r '.web.rewrites.enable')
	fi
	
	if [[ ! $REWRITES_ENABLED ]] || [[ $REWRITES_ENABLED = 'null' ]]; then

		box server set web.rewrites.enable=${URL_REWRITES:=true}

	else

		echo "INFO: Existing explict rewrite configuration detected in server.json. Environmental flags will be ignored."

	fi

echo "****************************************************************"