#!/bin/bash
set -euo pipefail

image=${1:-ortussolutions/commandbox:boxlang}
platform=${TEST_PLATFORM:-linux/amd64}
builder=$(docker context show)
workbenchImage=commandbox-progressive-workbench:$$
runtimeImage=commandbox-progressive-runtime:$$
container=commandbox-progressive-$$

cleanup () {
	local exitCode=$?
	trap - EXIT
	if [[ $exitCode != 0 ]]; then
		docker logs "$container" >&2 || true
	fi
	docker rm -f "$container" >/dev/null 2>&1 || true
	docker image rm "$runtimeImage" "$workbenchImage" >/dev/null 2>&1 || true
	exit "$exitCode"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

docker buildx build --builder "$builder" --platform "$platform" --load --progress plain \
	--build-arg BASE_IMAGE_ARG="$image" --target workbench --tag "$workbenchImage" \
	--file resources/examples/ProgressiveBuild.Dockerfile .
runwarJarPath=$(docker run --rm --platform "$platform" --entrypoint bash "$workbenchImage" -ec \
	'jq -er ".runwarJarPath | select(type == \"string\" and startswith(\"/\"))" "$LIB_DIR/serverHome/serverInfo.json"')

docker buildx build --builder "$builder" --platform "$platform" --load --progress plain \
	--build-arg BASE_IMAGE_ARG="$image" --tag "$runtimeImage" \
	--file resources/examples/ProgressiveBuild.Dockerfile .
[[ $(docker image inspect --format '{{.Config.User}}' "$runtimeImage") = commandbox:runwar ]]
docker run --rm --platform "$platform" --entrypoint bash \
	-e RUNWAR_JAR_PATH="$runwarJarPath" "$runtimeImage" -ec '
	[[ $(id -u) = 1000 && $(id -g) = 1000 ]]
	[[ $APP_DIR = /srv/app && $HOME = /home/commandbox ]]
	[[ $LIB_DIR = /opt/lib ]]
	[[ $COMMANDBOX_HOME = /opt/commandbox && $STARTUP_DIR = /opt/commandbox/run ]]
	[[ $BOXLANG_HOME = /opt/boxlang && $BOXLANG_INSTALL_HOME = /opt/boxlang ]]
	[[ $PWD = $APP_DIR ]]
	for runtimePath in "$HOME" "$APP_DIR" "$COMMANDBOX_HOME" "$BOXLANG_HOME" "$LIB_DIR/serverHome" "$STARTUP_DIR"; do
		[[ -d $runtimePath && -w $runtimePath && -x $runtimePath ]]
	done
	[[ ! -e /opt/bin && ! -e /opt/build ]]
	[[ -r $APP_DIR/index.cfm && -r $LIB_DIR/serverHome/serverInfo.json ]]
	[[ $RUNWAR_JAR_PATH = "$BOXLANG_HOME/modules/bx-cli/src/libExt/"* ]]
	[[ -r $RUNWAR_JAR_PATH && -s $RUNWAR_JAR_PATH ]]
	boxlangJars=( "$BOXLANG_HOME"/lib/boxlang-[0-9]*.jar )
	[[ -s ${boxlangJars[0]} ]]
	[[ -r $STARTUP_DIR/startup-final.env && -x $STARTUP_DIR/startup-final.sh ]]
	. "$STARTUP_DIR/startup-final.env"
	[[ $BOX_SERVER_APP_SERVERHOMEDIRECTORY = $LIB_DIR/serverHome ]]
	! command -v box
'

docker run -d --platform "$platform" --name "$container" -p 127.0.0.1::8080 "$runtimeImage" >/dev/null
checkServer () {
	local port
	port=$(docker inspect --format '{{(index (index .NetworkSettings.Ports "8080/tcp") 0).HostPort}}' "$container")
	curl --fail --silent --show-error --connect-timeout 2 --max-time 3 \
		--retry 60 --retry-delay 1 --retry-max-time 120 --retry-all-errors \
		"http://127.0.0.1:${port}/" >/dev/null
	docker exec "$container" bash -ec '
		found=false
		for process in /proc/[0-9]*; do
			if [[ $(readlink "$process/exe") = */java ]]; then
				[[ $(awk "/^Uid:/ {print \$2}" "$process/status") = 1000 ]]
				found=true
			fi
		done
		[[ $found = true ]]
	'
	docker exec "$container" bash -ec 'curl --fail --silent --show-error "$HEALTHCHECK_URI" >/dev/null'
}
checkServer
docker restart "$container" >/dev/null
checkServer
printf 'Progressive image paths, startup, and restart passed\n'