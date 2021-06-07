#!/bin/bash
# Set any error to exit non-zero
set -e

export DEBUG=true

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

echo "Generic server tests completed"

printf "\n\n*******************\n\n"

cd $APP_DIR
box server stop
cd $BUILD_DIR



# CFConfig Variables
echo "Tests the ability to specify a cfconfig file"

./tests/test.cfconfig.file.sh

echo "CFConfig file tests completed successfully"


printf "\n\n*******************\n\n"


# CFConfig Variables
echo "Tests the ability to run the environment in headless mode"

./tests/test.headless.sh

echo "HEADLESS environment variable tests completed successfully"

# Rewrites Environment variables
echo "Testing the ability to specify to turn rewrites off via an environment variable"

export URL_REWRITES=true

runOutput="$( ${BUILD_DIR}/run.sh )"

printf "${runOutput}"

./tests/test.up.sh

if [[ ${runOutput} != *"The environment variable URL_REWRITES has been deprecated"* ]];then
	echo "Rewrites were not enabled from the environment variable!"
	exit 1
fi

# cleanup
unset URL_REWRITES
cd $APP_DIR
box server stop

echo "Rewrite environment tests completed successfully"

cd $BUILD_DIR

echo "Commandbox rewrite convention tests completed successfully"


printf "\n\n*******************\n\n"
cd $BUILD_DIR

echo "All tests completed successfully"

