#!/bin/bash
set -e

[[ $APP_DIR = /srv/app ]]
[[ $BIN_DIR = /opt/bin ]]
[[ $LIB_DIR = /opt/lib ]]
[[ $BUILD_DIR = /opt/build ]]
[[ $COMMANDBOX_HOME = /opt/commandbox ]]
[[ $BOXLANG_HOME = /opt/boxlang ]]
[[ $BOXLANG_INSTALL_HOME = /opt/boxlang ]]
[[ $HOME = /home/commandbox ]]
[[ $STARTUP_DIR = /opt/commandbox/run ]]
[[ $(id -u) = "${EXPECTED_UID:-1000}" ]]
[[ $(command -v boxlang) = "$BOXLANG_INSTALL_HOME/bin/boxlang" ]]
[[ $(command -v box) = "$BIN_DIR/box" ]]
[[ $CLASSPATH = "$LIB_DIR/java/classes" ]]
[[ ! -d $HOME/.CommandBox && ! -d $HOME/.boxlang ]]
[[ ! -d /usr/local/boxlang ]]
if [[ $(id -u) != 0 ]]; then
	[[ ! -w $BIN_DIR && ! -w $BIN_DIR/box && ! -w $BUILD_DIR && ! -w $BUILD_DIR/run.sh ]]
	[[ ! -w $(readlink -f "$(command -v java)") ]]
fi
for runtimePath in "$HOME" "$APP_DIR" "$COMMANDBOX_HOME" "$BOXLANG_HOME" "$LIB_DIR/serverHome" "$STARTUP_DIR"; do
	touch "$runtimePath/path-test"
	rm "$runtimePath/path-test"
done

fixtureDir=$(mktemp -d)
trap 'rm -rf "$fixtureDir"' EXIT
chmod 755 "$fixtureDir"
mkdir -p "$fixtureDir/build/util" "$fixtureDir/bin" "$fixtureDir/app" \
	"$fixtureDir/commandbox" "$fixtureDir/boxlang" "$fixtureDir/lib" "$fixtureDir/home" "$fixtureDir/run"
chmod 555 "$fixtureDir/bin"
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
[[ -w $COMMANDBOX_HOME && -w $BOXLANG_HOME && -w $STARTUP_DIR ]]
if [[ $(id -u) != 0 ]]; then
	[[ ! -w $BIN_DIR ]]
fi
[[ -w $BOX_SERVER_APP_SERVERHOMEDIRECTORY ]]
rm -f "$STARTUP_DIR/path-test"
touch "$APP_DIR/path-test" "$COMMANDBOX_HOME/path-test" \
	"$BOXLANG_HOME/path-test" "$STARTUP_DIR/path-test" \
	"$BOX_SERVER_APP_SERVERHOMEDIRECTORY/path-test"
printf 'Path checks passed as UID %s\n' "$(id -u)"
STARTUP

runCase () {
	local expectedHome=$1
	shift
	env -u BOX_SERVER_APP_SERVERHOMEDIRECTORY -u SERVER_HOME_DIRECTORY \
		-u BOX_SERVER_SERVERCONFIGFILE -u BOX_SERVER_APP_CFENGINE \
		APP_DIR="$fixtureDir/app" BIN_DIR="$fixtureDir/bin" \
		LIB_DIR="$fixtureDir/lib" BUILD_DIR="$fixtureDir/build" \
		COMMANDBOX_HOME="$fixtureDir/commandbox" BOXLANG_HOME="$fixtureDir/boxlang" \
		BOXLANG_INSTALL_HOME="$fixtureDir/boxlang" \
		HOME="$fixtureDir/home" STARTUP_DIR="$fixtureDir/run" \
		USER=ignored-legacy-user USER_ID=4242 EXPECTED_UID="$(id -u)" \
		EXPECTED_PATH="$PATH" \
		EXPECTED_COMMANDBOX_HOME="$fixtureDir/commandbox" \
		EXPECTED_BOXLANG_HOME="$fixtureDir/boxlang" EXPECTED_SERVER_HOME="$expectedHome" \
		"$@" "$fixtureDir/build/run.sh"
}

mkdir -p "$fixtureDir/lib/serverHome"
runCase "$fixtureDir/lib/serverHome"
runCase "$fixtureDir/lib/serverHome"

printf '{"app":{"serverHomeDirectory":"relative-home"}}\n' > "$fixtureDir/app/server.json"
runCase relative-home
[[ $(stat -c %u "$fixtureDir/app/relative-home") = "$(id -u)" ]]

printf '{"app":{"serverHomeDirectory":"%s"}}\n' "$fixtureDir/json-home" > "$fixtureDir/app/server.json"
runCase "$fixtureDir/json-home"
runCase "$fixtureDir/env-home" BOX_SERVER_APP_SERVERHOMEDIRECTORY="$fixtureDir/env-home"
runCase "$fixtureDir/alias-home" SERVER_HOME_DIRECTORY="$fixtureDir/alias-home"

printf '{"app":{"serverHomeDirectory":null}}\n' > "$fixtureDir/app/server.json"
runCase "$fixtureDir/lib/serverHome"

if [[ $(id -u) != 0 ]]; then
	chmod 555 "$fixtureDir/home"
	originalOwner=$(stat -c %u "$fixtureDir/home")
	if runCase "$fixtureDir/lib/serverHome" > "$fixtureDir/denied.log" 2>&1; then
		echo 'An unwritable runtime directory should fail startup'
		exit 1
	fi
	grep -q 'Grant this UID or shared GID 1000 write access' "$fixtureDir/denied.log"
	[[ $(stat -c %u "$fixtureDir/home") = "$originalOwner" ]]
	chmod 755 "$fixtureDir/home"
fi

cp "$fixtureDir/build/util/start-server.sh" "$fixtureDir/run/startup-final.sh"
printf 'export BOX_SERVER_APP_SERVERHOMEDIRECTORY=%q\n' "$fixtureDir/final home" > "$fixtureDir/run/startup-final.env"
chmod +x "$fixtureDir/run/startup-final.sh"
printf 'not JSON\n' > "$fixtureDir/app/server.json"
runCase "$fixtureDir/final home" BOX_SERVER_APP_SERVERHOMEDIRECTORY=/ignored
runCase "$fixtureDir/final home"

mkdir -p "$fixtureDir/custom home"
touch "$fixtureDir/custom home/restrictive-file"
chmod 600 "$fixtureDir/custom home/restrictive-file"
env HOME="$fixtureDir/home" APP_DIR="$fixtureDir/app" \
	BIN_DIR="$fixtureDir/bin" BUILD_DIR="$fixtureDir/build" \
	COMMANDBOX_HOME="$fixtureDir/commandbox" BOXLANG_HOME="$fixtureDir/boxlang" \
	BOXLANG_INSTALL_HOME="$fixtureDir/boxlang" LIB_DIR="$fixtureDir/lib" \
	STARTUP_DIR="$fixtureDir/run" \
	bash "$BUILD_DIR/util/prepare-runtime.sh" "$fixtureDir/custom home"
[[ $(stat -c %a "$fixtureDir/custom home") = 2775 ]]
[[ $(stat -c %a "$fixtureDir/custom home/restrictive-file") = 660 ]]

echo "Filesystem location and native-user regression checks passed"