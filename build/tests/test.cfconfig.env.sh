cd $APP_DIR

echo "Starting server with cfconfig environment variable set"

runOutput="$( ${BUILD_DIR}/run.sh )"
printf "${runOutput}"

$BUILD_DIR/tests/test.up.sh

if [[ ${runOutput} != *"Setting cfconfig variable adminPassword"* ]];then
	echo "CFCONFIG environment variable was not detected or set"
	exit 1
fi

# cleanup
box server stop
rm -f $APP_DIR/*.json
