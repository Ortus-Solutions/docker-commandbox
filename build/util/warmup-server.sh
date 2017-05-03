echo "Starting up container in test mode"
# We send up our "testing" flag to prevent the default CommandBox image run script from begining to tail output, thus stalling our build
export IMAGE_TESTING_IN_PROGRESS=true
export cfconfig_adminPassword=commandbox
# Run our normal build script, which will warm up our server and add it to the image
${BUILD_DIR}/run.sh
# Stop our server
cd ${APP_DIR} && box server stop
# Remove our testing flag, so that our container will start normally when its run
unset IMAGE_TESTING_IN_PROGRESS
unset cfconfig_adminPassword
echo "Container successfully warmed up"