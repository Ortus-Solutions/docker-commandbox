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
	echo "CommandBox Binary is not available"
	exit 1
fi

if [[ ! -f ${APP_DIR}/index.cfm ]]; then
	echo "Test directory was not mounted in to ${APP_DIR}"
	echo $( ls -la $APP_DIR )
	exit 1
fi

cd $BUILD_DIR

# Test default environment with no additional variables
echo "Tests that basic commandbox system commands work in this environment"

./tests/test.commandbox.sh

echo "CommandBox successfully tested"

printf "\n\n*******************\n\n"

# Test default environment with no additional variables
echo "Tests that a generic server is up and running"

runOutput="$( ${BUILD_DIR}/run.sh )"

printf %s ${runOutput}

./tests/test.up.sh

echo "Generic server tests completed"

cd $APP_DIR
box server stop
cd $BUILD_DIR

echo "Engine tests completed successfully"
