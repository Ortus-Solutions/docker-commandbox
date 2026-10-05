#!/bin/bash
set -e

image=${1:?Pass a built CommandBox image}
container=commandbox-runtime-$$
finalImage=commandbox-final-test:$$
cleanup () {
	docker rm -f "$container" >/dev/null 2>&1 || true
	docker image rm "$finalImage" >/dev/null 2>&1 || true
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
	for identity in default 1002:1000 1002:1002; do
		userArgs=()
		expectedUid=1000
		if [[ $identity != default ]]; then
			userArgs=( --user "$identity" --group-add 1000 )
			expectedUid=1002
		fi
		finalArgs=()
		if [[ $mode = finalized ]]; then
			finalArgs=( -e BOX_SERVER_APP_SERVERHOMEDIRECTORY=/ignored )
		fi
		docker run -d --name "$container" "${userArgs[@]}" "${finalArgs[@]}" -e EXPECTED_UID="$expectedUid" "$selectedImage" >/dev/null
		checkServer
		docker exec "$container" bash -ec 'test ! -w "$BIN_DIR"; test ! -w "$BUILD_DIR"; test -f "$STARTUP_DIR/startup.sh" || test -f "$STARTUP_DIR/startup-final.sh"'
		docker restart "$container" >/dev/null
		checkServer
		docker rm -f "$container" >/dev/null
		printf '%s startup and restart passed with %s identity\n' "$mode" "$identity"
	done
done