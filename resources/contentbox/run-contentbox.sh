cd $APP_DIR

# If our installer flag has been passed, then add that
if [[ $installer ]]; then
	box install contentbox-installer
fi

if [[ ! $ENV{"contentbox.cb_media_directoryRoot"} ]]; then
	env "contentbox.cb_media_directoryRoot=/app/includes/shared/media" bash
fi

mkdir -p $ENV{"contentbox.cb_media_directoryRoot"}

# Now that we've set up contentbox, stand-up the rest with our normal runfile
cd $BUILD_DIR
./run.sh