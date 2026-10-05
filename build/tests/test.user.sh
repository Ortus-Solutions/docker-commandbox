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

expectedUid=$(id -u)
[[ $expectedUid != 0 ]]
echo "Starting server with container UID $expectedUid"

[[ $COMMANDBOX_HOME = "$originalCommandBoxHome" ]]
[[ $BOXLANG_HOME = "$originalBoxLangHome" ]]
[[ -f $COMMANDBOX_HOME/user-test-sentinel && -f $BOXLANG_HOME/user-test-sentinel ]]
[[ ! -e $HOME/.CommandBox && ! -e $HOME/.boxlang ]]
for attempt in 1 2; do
	if ! runOutput="$( "${BUILD_DIR}/run.sh" )"; then
		printf '%s\n' "$runOutput"
		exit 1
	fi
	printf '%s\n' "$runOutput"
	"$BUILD_DIR/tests/test.up.sh"
	pidFile=$(box server info property=pidfile | xargs)
	serverPid=$(< "$pidFile")
	[[ $(awk '/^Uid:/ {print $2}' "/proc/$serverPid/status") = "$expectedUid" ]]
	[[ -f $COMMANDBOX_HOME/user-test-sentinel && -f $BOXLANG_HOME/user-test-sentinel ]]
	box server stop
done

# cleanup
rm -f "$COMMANDBOX_HOME/user-test-sentinel" "$BOXLANG_HOME/user-test-sentinel"