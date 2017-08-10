#!/bin/bash
set -e

if [[ $BE ]] || [[ $be ]]; then
	echo "INFO: Bleeding Edge installation specified."
	cd ${APP_DIR} && box install contentbox-installer@be --production
else 
	echo "INFO: Latest Stable Release installation specified."
	cd ${APP_DIR} && box install contentbox-installer --production
fi;

# Remove DSN creator no need to use it
rm -Rf ${APP_DIR}/modules/contentbox-dsncreator

# Ensure the modules_app directory exists or ACF will blow up
mkdir -p ${APP_DIR}/modules_app

# Ensure no server.json file exists
rm -f ${APP_DIR}/server.json

# Copy over our resources
echo "Copying over ContentBox Container Overrides"
cp -rvf ${BUILD_DIR}/contentbox-app/* ${APP_DIR}

# Debug the App Dir
echo "Final App Dir"
ls -la ${APP_DIR}
#cat ${APP_DIR}/Application.cfc
#cat ${APP_DIR}/config/CacheBox.cfc

# Finalize Build Dir
rm -Rf ${BUILD_DIR}/contentbox-app
echo "Final Build Dir"
cd $BUILD_DIR
ls -la