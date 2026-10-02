#!/bin/bash
set -e

[[ $APP_DIR = /srv/app ]]
[[ $BIN_DIR = /opt/bin ]]
[[ $LIB_DIR = /opt/lib ]]
[[ $BUILD_DIR = /opt/build ]]
[[ $COMMANDBOX_HOME = /opt/commandbox ]]
[[ $BOXLANG_HOME = /opt/boxlang ]]
[[ $BOXLANG_INSTALL_HOME = /opt/boxlang ]]
[[ $(command -v boxlang) = "$BOXLANG_INSTALL_HOME/bin/boxlang" ]]
[[ $(command -v box) = "$BIN_DIR/box" ]]
[[ $CLASSPATH = "$LIB_DIR/java/classes" ]]
[[ ! -d /root/.CommandBox && ! -d /root/.boxlang ]]
[[ ! -d /usr/local/boxlang ]]

fixtureDir=$(mktemp -d)
trap 'rm -rf "$fixtureDir"' EXIT
chmod 755 "$fixtureDir"
mkdir -p "$fixtureDir/build/util" "$fixtureDir/bin" "$fixtureDir/app" \
	"$fixtureDir/commandbox" "$fixtureDir/boxlang" "$fixtureDir/lib"
cp "$BUILD_DIR/run.sh" "$fixtureDir/build/run.sh"
cp "$BUILD_DIR/util/log.sh" "$BUILD_DIR/util/compat-env.sh" \
	"$BUILD_DIR/util/env-secrets-expand.sh" "$fixtureDir/build/util/"
chmod +x "$fixtureDir/build/run.sh"
touch "$fixtureDir/commandbox/sentinel" "$fixtureDir/boxlang/sentinel"

cat > "$fixtureDir/build/util/start-server.sh" <<'STARTUP'
[[ $(id -u) = "$EXPECTED_UID" ]]
[[ $PATH = "$EXPECTED_PATH" ]]
[[ $COMMANDBOX_HOME = "$EXPECTED_COMMANDBOX_HOME" ]]
[[ $BOXLANG_HOME = "$EXPECTED_BOXLANG_HOME" ]]
[[ $BOX_SERVER_APP_SERVERHOMEDIRECTORY = "$EXPECTED_SERVER_HOME" ]]
[[ -f $COMMANDBOX_HOME/sentinel && -f $BOXLANG_HOME/sentinel ]]
[[ ! -e $HOME/.CommandBox && ! -e $HOME/.boxlang ]]
[[ -w $COMMANDBOX_HOME && -w $BOXLANG_HOME && -w $BIN_DIR ]]
[[ -w $BOX_SERVER_APP_SERVERHOMEDIRECTORY ]]
rm -f "$BIN_DIR/path-test"
touch "$APP_DIR/path-test" "$COMMANDBOX_HOME/path-test" \
	"$BOXLANG_HOME/path-test" "$BIN_DIR/path-test" \
	"$BOX_SERVER_APP_SERVERHOMEDIRECTORY/path-test"
printf 'Path checks passed as UID %s\n' "$(id -u)"
STARTUP

runCase () {
	local selectedUser=$1
	local expectedUid=$2
	local expectedHome=$3
	shift 3
	env -u BOX_SERVER_APP_SERVERHOMEDIRECTORY -u SERVER_HOME_DIRECTORY \
		-u BOX_SERVER_SERVERCONFIGFILE -u BOX_SERVER_APP_CFENGINE \
		APP_DIR="$fixtureDir/app" BIN_DIR="$fixtureDir/bin" \
		LIB_DIR="$fixtureDir/lib" BUILD_DIR="$fixtureDir/build" \
		COMMANDBOX_HOME="$fixtureDir/commandbox" BOXLANG_HOME="$fixtureDir/boxlang" \
		BOXLANG_INSTALL_HOME="$fixtureDir/boxlang" \
		USER="$selectedUser" USER_ID="$expectedUid" EXPECTED_UID="$expectedUid" \
		EXPECTED_PATH="$PATH" \
		EXPECTED_COMMANDBOX_HOME="$fixtureDir/commandbox" \
		EXPECTED_BOXLANG_HOME="$fixtureDir/boxlang" EXPECTED_SERVER_HOME="$expectedHome" \
		"$@" "$fixtureDir/build/run.sh"
}

mkdir -p "$fixtureDir/lib/serverHome"
runCase root 0 "$fixtureDir/lib/serverHome"
runCase pathuser 1003 "$fixtureDir/lib/serverHome"
runCase pathuser 1003 "$fixtureDir/lib/serverHome"

printf '{"app":{"serverHomeDirectory":"relative-home"}}\n' > "$fixtureDir/app/server.json"
runCase pathuser 1003 relative-home
[[ $(stat -c %u "$fixtureDir/app/relative-home") = 1003 ]]

printf '{"app":{"serverHomeDirectory":"%s"}}\n' "$fixtureDir/json-home" > "$fixtureDir/app/server.json"
runCase pathuser 1003 "$fixtureDir/json-home"
runCase pathuser 1003 "$fixtureDir/env-home" BOX_SERVER_APP_SERVERHOMEDIRECTORY="$fixtureDir/env-home"
runCase pathuser 1003 "$fixtureDir/alias-home" SERVER_HOME_DIRECTORY="$fixtureDir/alias-home"

printf '{"app":{"serverHomeDirectory":null}}\n' > "$fixtureDir/app/server.json"
runCase pathuser 1003 "$fixtureDir/lib/serverHome"

cp "$fixtureDir/build/util/start-server.sh" "$fixtureDir/bin/startup-final.sh"
printf 'export BOX_SERVER_APP_SERVERHOMEDIRECTORY=%q\n' "$fixtureDir/final home" > "$fixtureDir/bin/startup-final.env"
chmod +x "$fixtureDir/bin/startup-final.sh"
printf 'not JSON\n' > "$fixtureDir/app/server.json"
runCase finalpathuser 1004 "$fixtureDir/final home" BOX_SERVER_APP_SERVERHOMEDIRECTORY=/ignored
runCase finalpathuser 1004 "$fixtureDir/final home"
runCase pathuser 1003 "$fixtureDir/final home"

echo "Filesystem location and user-switch regression checks passed"