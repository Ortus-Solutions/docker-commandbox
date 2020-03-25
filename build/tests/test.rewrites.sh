#!/bin/bash
# Perform reset operations now, before we start issuing exit codes

# Clear out any previous runtime JSON files
rm -f $APP_DIR/*.json

# Clear out any previous runtime-created modules
rm -rf $APP_DIR/modules

cd ${APP_DIR}

box server set web.rewrites.enable=true

echo "Starting server with rewrites enabled and no configuration file"

runOutput="$( ${BUILD_DIR}/run.sh )"

printf "${runOutput}\n"

$BUILD_DIR/tests/test.up.sh

if [[ ${runOutput} != *"Existing rewrite flag detected"* ]];then
	echo "Rewrite flag provided by server.json was not honored"
	exit 1
fi

box server stop

cp $BUILD_DIR/resources/urlrewrite.xml $APP_DIR/urlrewrite.xml
box server set web.rewrites.config=$APP_DIR/urlrewrite.xml

echo "Starting server with rewrites enabled and configuration file"

runOutput="$( ${BUILD_DIR}/run.sh )"

printf "${runOutput}\n"

$BUILD_DIR/tests/test.up.sh

if [[ ${runOutput} != *"Existing rewrite configuration detected"* ]];then
	echo "Rewrite config provided by server.json was not honored"
	exit 1
fi

box server stop

rm -f $APP_DIR/*.xml