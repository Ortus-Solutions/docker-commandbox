#!/bin/bash
# Set any error to exit non-zero
set -e
# Perform reset operations now, before we start issuing exit codes

# Clear out any previous runtime JSON files
rm -f $APP_DIR/*.json

# Clear out any previous runtime-created modules
rm -rf $APP_DIR/modules

cd ${APP_DIR}

originalCommandBoxHome=$COMMANDBOX_HOME
originalBoxLangHome=$BOXLANG_HOME
touch "$COMMANDBOX_HOME/user-test-sentinel" "$BOXLANG_HOME/user-test-sentinel"

export USER=runtimeuser
export USER_ID=1002

echo "Starting server with Runtime user set to ${USER}"

runOutput="$( ${BUILD_DIR}/run.sh )"

printf '%s\n' "${runOutput}"

$BUILD_DIR/tests/test.up.sh

if [[ ${runOutput} != *"Configuration set to non-root user"* ]];then
	echo "Environment variable USER was not applied at runtime"
	exit 1
fi

[[ $COMMANDBOX_HOME = "$originalCommandBoxHome" ]]
[[ $BOXLANG_HOME = "$originalBoxLangHome" ]]
[[ -f $COMMANDBOX_HOME/user-test-sentinel && -f $BOXLANG_HOME/user-test-sentinel ]]
[[ $(stat -c %u "$COMMANDBOX_HOME") = "$USER_ID" ]]
[[ $(stat -c %u "$BOXLANG_HOME") = "$USER_ID" ]]
[[ $(stat -c %u "$APP_DIR") = "$USER_ID" ]]
[[ ! -e /home/$USER/.CommandBox && ! -e /home/$USER/.boxlang ]]
box server stop

runOutput="$( "${BUILD_DIR}/run.sh" )"
printf '%s\n' "$runOutput"
"$BUILD_DIR/tests/test.up.sh"
[[ -f $COMMANDBOX_HOME/user-test-sentinel && -f $BOXLANG_HOME/user-test-sentinel ]]

# cleanup
unset USER
unset USER_ID
box server stop
rm -f "$COMMANDBOX_HOME/user-test-sentinel" "$BOXLANG_HOME/user-test-sentinel"