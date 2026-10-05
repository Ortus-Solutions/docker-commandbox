#!/bin/bash
set -e

image=${1:?Pass a built CommandBox image}
shift
if [[ $# = 0 ]]; then
	set -- default 1002:1000 1002:1002 root
fi
identities=( "$@" )
container=commandbox-runtime-$$
finalImage=commandbox-final-test:$$
rootImage=commandbox-root-test:$$
cleanup () {
	docker rm -f "$container" >/dev/null 2>&1 || true
	docker image rm "$finalImage" >/dev/null 2>&1 || true
	docker image rm "$rootImage" >/dev/null 2>&1 || true
}
trap cleanup EXIT

checkServer () {
	if ! docker exec "$container" curl --fail --silent --show-error --retry 60 --retry-delay 1 --retry-connrefused http://127.0.0.1:8080/ >/dev/null; then
		docker logs "$container"
		return 1
	fi
	docker exec "$container" bash -ec '
		found=false
		for process in /proc/[0-9]*; do
			if [[ $(readlink "$process/exe") = */java ]]; then
				[[ $(awk "/^Uid:/ {print \$2}" "$process/status") = "$EXPECTED_UID" ]]
				found=true
			fi
		done
		[[ $found = true ]]
	'
}

for mode in normal finalized; do
	selectedImage=$image
	if [[ $mode = finalized ]]; then
		docker build --build-arg BASE_IMAGE_ARG="$image" --tag "$finalImage" --file - . <<'DOCKERFILE'
ARG BASE_IMAGE_ARG
FROM ${BASE_IMAGE_ARG}
COPY build/ /opt/build/
RUN FINALIZE_STARTUP=true "$BUILD_DIR/run.sh" && printf 'not JSON\n' > "$APP_DIR/server.json"
DOCKERFILE
		selectedImage=$finalImage
	fi
	for identity in "${identities[@]}"; do
		runtimeImage=$selectedImage
		userArgs=()
		expectedUid=1000
		if [[ $identity = root ]]; then
			expectedUid=0
			docker build --build-arg BASE_IMAGE_ARG="$selectedImage" --tag "$rootImage" --file - . <<'DOCKERFILE'
ARG BASE_IMAGE_ARG
FROM ${BASE_IMAGE_ARG}
COPY build/ /opt/build/
USER root
RUN test "$(id -u)" = 0 && box version
DOCKERFILE
			runtimeImage=$rootImage
		elif [[ $identity != default ]]; then
			userArgs=( --user "$identity" --group-add 1000 )
			expectedUid=1002
		fi
		finalArgs=()
		if [[ $mode = finalized ]]; then
			finalArgs=( -e BOX_SERVER_APP_SERVERHOMEDIRECTORY=/ignored )
		fi
		docker run -d --name "$container" "${userArgs[@]}" "${finalArgs[@]}" -e EXPECTED_UID="$expectedUid" "$runtimeImage" >/dev/null
		checkServer
		docker exec "$container" bash -ec 'if [[ $EXPECTED_UID != 0 ]]; then test ! -w "$BIN_DIR"; test ! -w "$BUILD_DIR"; fi; test -f "$STARTUP_DIR/startup.sh" || test -f "$STARTUP_DIR/startup-final.sh"'
		docker restart "$container" >/dev/null
		checkServer
		docker rm -f "$container" >/dev/null
		printf '%s startup and restart passed with %s identity\n' "$mode" "$identity"
	done
done