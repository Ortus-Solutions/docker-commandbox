#!/bin/bash
set -e

cd $APP_DIR

if [[ $express ]] || [[ $EXPRESS ]]; then

	echo "Express installation specified.  Configuring HSQL Database."

	if [[ ! $HSQL_DIR ]]; then
		export HSQL_DIR=/data/contentbox/db
		# H2 Database Directory
		mkdir -p ${HSQL_DIR}
	fi

	#check for a lock file and remove it so we can start up
	if [[ -f ${HSQL_DIR}/contentbox.lck ]]; then
		rm -f ${HSQL_DIR}/contentbox.lck
	fi

fi


# ContentBox Dependencies
echo "Installing ContentBox Dependencies."
box install

if [[ ! -f ${APP_DIR}/server.json ]] || [[ $rewrites ]] || [[ $rewritesEnable ]]; then
	echo "Enabling rewrites..."
	box server set web.rewrites.enable=true
fi

# If our installer flag has not been passed, then remove that module
if [[ ! $installer ]] && [[ ! $install ]]; then
	rm -rf ${APP_DIR}/modules/contentbox-installer
fi

# Check for path environment variables and then apply convention routes to them if not specified
if [[ ! $contentbox_cb_media_directoryRoot ]]; then
	export contentbox_cb_media_directoryRoot=/app/includes/shared/media 
fi

mkdir -p $contentbox_cb_media_directoryRoot

echo "Contentbox media root set as ${contentbox_cb_media_directoryRoot}"

# Now that we've set up contentbox, stand-up the rest with our normal runfile
cd $BUILD_DIR
./run.sh