cd $APP_DIR

box cfconfig set adminPassword=testing to=$APP_DIR/cfconfig.json

if [[ ! -f ${APP_DIR}/cfconfig.json ]]; then
	echo "CFConfig file was not written to ${APP_DIR}"
	exit 1
fi

export CFCONFIG=$APP_DIR/cfconfig.json

echo "Starting server with cfconfig file variable set"

runOutput="$( ${BUILD_DIR}/run.sh )"

printf "${runOutput}\n"

$BUILD_DIR/tests/test.up.sh

if [[ ${runOutput} != *"Engine configuration file detected"* ]];then
	echo "CFCONFIG file variable was not detected or set"
	exit 1
fi

# If we have a Lucee server, check that the web and server passwords were set to the same
if [[ $ENGINE_VENDOR == 'lucee' ]] && [[ ${runOutput} != *"[adminPassword] set"* ]];then
	echo "Default Lucee administrator password not set to web admin password"
	exit 1
fi


# cleanup
unset CFCONFIG
box server stop