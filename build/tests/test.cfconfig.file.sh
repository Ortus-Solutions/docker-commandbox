cd $APP_DIR

# The file needs to exist already when single server mode is on
echo "{}" > $APP_DIR/cfconfig.json

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

if [[ ${BOX_SERVER_CFCONFIGFILE} != $CFCONFIG ]];then
	echo "CFCONFIG file variable was not detected or set"
	exit 1
fi

# cleanup
unset CFCONFIG
box server stop

echo '{"adminPassword":"testing"}' > $APP_DIR/.cfconfig.json

echo "Starting server with convention route .cfconfig.json file in place"

runOutput="$( ${BUILD_DIR}/run.sh )"

printf "${runOutput}\n"

$BUILD_DIR/tests/test.up.sh

if [[ ${runOutput} != *"Convention .cfconfig.json found"* ]];then
	echo ".cfconfig.json file not detected"
	exit 1
fi

