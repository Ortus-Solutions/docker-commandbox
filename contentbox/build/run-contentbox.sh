#!/bin/bash
set -e

cd $APP_DIR

if [[ $express ]] || [[ $EXPRESS ]]; then

	echo "INFO: Express installation specified.  Configuring H2 Database."

	if [[ ! $H2_DIR ]]; then
		export H2_DIR=/data/contentbox/db
		# H2 Database Directory
		mkdir -p ${H2_DIR}
	fi

	echo "INFO: H2 Database set to ${H2_DIR}"

	#check for a lock file and remove it so we can start up
	if [[ -f ${H2_DIR}/contentbox.lck ]]; then
		rm -f ${H2_DIR}/contentbox.lck
	fi

fi

# ContentBox Dependencies
#echo "INFO: Installing ContentBox Dependencies."
#box install

if [[ ! -f ${APP_DIR}/server.json ]] || [[ $rewrites ]] || [[ $rewritesEnable ]]; then
	echo "INFO: Enabling rewrites..."
	box server set web.rewrites.enable=true
fi

# If our installer flag has not been passed, then remove that module
if [[ ! $installer ]] && [[ ! $install ]] && [[ ! $INSTALL ]]; then
	echo "INFO: Removing installer..."
	rm -rf ${APP_DIR}/modules/contentbox-installer
fi

# Check for path environment variables and then apply convention routes to them if not specified
if [[ ! $contentbox_default_cb_media_directoryRoot ]]; then
	export contentbox_default_cb_media_directoryRoot=/app/includes/shared/media 
fi
# Create media directory, just in case.
mkdir -p $contentbox_default_cb_media_directoryRoot

echo "INFO: Contentbox media root set as ${contentbox_default_cb_media_directoryRoot}"

# Now that we've set up contentbox, stand-up the rest with our normal CommandBox Build File
cd $BUILD_DIR
./run.sh