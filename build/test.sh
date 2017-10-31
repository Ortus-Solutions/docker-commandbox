#!/bin/bash
# Set any error to exit non-zero
set -e

# Test that expected variables and binaries are in place
if [[ ! $BUILD_DIR ]]; then
	echo "BUILD_DIR environment variable not defined."
	exit 1
fi

if [[ ! $APP_DIR ]]; then
	echo "APP_DIR environment variable not defined."
	exit 1
fi

COMMANDBOX_VERSION=$(box version)

if [[ ! $COMMANDBOX_VERSION ]]; then
	echo "CommandboxBox Binary is not available"
	exit 1
fi


if [[ ! -f ${APP_DIR}/index.cfm ]]; then
	echo "Test directory was not mounted in to ${APP_DIR}"
	echo $( ls -la $APP_DIR )
	exit 1
fi

cd $BUILD_DIR

printf "\n\n*******************\n\n"

# Test default environment with no additional variables
echo "Tests that basic commandbox system commands work in this environment"

./tests/test.commandbox.sh

echo "CommandBox successfully tested"

printf "\n\n*******************\n\n"

# Test default environment with no additional variables
echo "Tests that a generic server is up and running"

runOutput="$( ${BUILD_DIR}/run.sh )"

printf "${runOutput}"

./tests/test.up.sh

# Test our opinionated password setting when the default is not changed
if [[ ${runOutput} != *"Configuration did not detect any known mechanisms for changing the default password"* ]];then
	echo "The default password was not changed when no password was specified"
	exit 1
fi

# cleanup
cd $APP_DIR
box server stop
rm -f $APP_DIR/server.json

echo "Generic server tests completed"

printf "\n\n*******************\n\n"
cd $BUILD_DIR

# CFConfig Variables
echo "Testing the ability to specify a cfconfig variable"

export cfconfig_adminPassword="testing"

./tests/test.cfconfig.env.sh

unset cfconfig_adminPassword

echo "CFConfig environment variable tests completed successfully"

# CFConfig Variables
echo "Tests the ability to specify a cfconfig file"

./tests/test.cfconfig.file.sh

echo "CFConfig file tests completed successfully"


printf "\n\n*******************\n\n"

# Rewrites Environment variables
echo "Testing the ability to specify to turn rewrites off via an environment variable"

export URL_REWRITES=true

runOutput="$( ${BUILD_DIR}/run.sh )"

printf "${runOutput}"

./tests/test.up.sh

if [[ ${runOutput} != *"Set web.rewrites.enable = true"* ]];then
	echo "Rewrites were not enabled from the environment variable!"
	exit 1
fi

# cleanup
unset URL_REWRITES
cd $APP_DIR
box server stop

echo "Rewrite environment tests completed successfully"


printf "\n\n*******************\n\n"
cd $BUILD_DIR

echo "All tests completed successfully"

