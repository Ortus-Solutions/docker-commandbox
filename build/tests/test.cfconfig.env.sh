cd $APP_DIR

echo "Starting server with cfconfig environment variable set"

export cfconfig_adminPassword=1am53cur3

runOutput="$( ${BUILD_DIR}/run.sh )"
printf "${runOutput}\n"

$BUILD_DIR/tests/test.up.sh

if [[ ${runOutput} != *"[adminPassword] set"* ]];then
	echo "CFCONFIG environment variable was not detected or set"
	exit 1
fi

# cleanup
unset cfconfig_adminPassword
box server stop
