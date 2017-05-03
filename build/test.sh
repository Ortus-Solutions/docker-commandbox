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
echo "Tests that a generic server is up and running"

./run.sh
./tests/test.up.sh

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
cd $BUILD_DIR

echo "All tests completed successfully"

