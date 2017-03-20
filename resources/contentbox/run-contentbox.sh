cd $APP_DIR

# H2 Database Directory
mkdir $APP_DIR/.db

# ContentBox Dependencies
box install

# If our installer flag has been passed, then add that
if [[ -z "${installer}" ]]; then
	box install contentbox-installer@be
fi

if [[ ! $(printenv contentbox.cb_media_directoryRoot) ]]; then
	env "contentbox.cb_media_directoryRoot=/app/includes/shared/media" bash
fi

mkdir -p $ENV{"contentbox.cb_media_directoryRoot"}

# Now that we've set up contentbox, stand-up the rest with our normal runfile
cd $BUILD_DIR
./run.sh