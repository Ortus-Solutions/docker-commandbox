echo "****************************************************************"
echo "INFO: Rewrite Flag detected, updating configuration..."

	if [[ -f $APP_DIR/server.json ]]; then
		REWRITE_ENABLE=$(cat server.json | jq -r '.web.rewrites.enable')
	fi
	
	if [[ ! $REWRITE_ENABLE ]] || [[ $REWRITE_ENABLE = 'null' ]]; then

		box server set web.rewrites.enable=true

	else

		echo "WARN: Existing rewrite configuration detected.  Could not apply rewrites configuration."

	fi

echo "****************************************************************"