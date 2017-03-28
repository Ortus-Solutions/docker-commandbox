cd $APP_DIR

box server stop
rm -f $APP_DIR/server.json
runOutput="$( ${BUILD_DIR}/run.sh )"

if [[ ${runOutput} != *"Setting cfconfig variable adminPassword"* ]];then
	echo "CFCONFIG environment variable was not detected or set"
	exit 1
fi
