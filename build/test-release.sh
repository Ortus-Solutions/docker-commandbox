#!/bin/bash
set -euo pipefail

phase=${1:?Supply build, integration, secrets, diagnostics, or cleanup}
: "${COMPOSE_PROJECT_NAME:?}" "${TEST_IMAGE:?}"
diagnosticsDir=${RELEASE_DIAGNOSTICS_DIR:-${RUNNER_TEMP:-${TMPDIR:-/tmp}}/release-diagnostics}
mkdir -p "$diagnosticsDir"

recordResources () {
	{
		date -u
		df -h
		if command -v free >/dev/null; then free -m; fi
		timeout --kill-after=5s 20s docker version || true
		timeout --kill-after=5s 20s docker compose version || true
		timeout --kill-after=5s 20s docker buildx ls || true
		timeout --kill-after=5s 20s docker system df || true
	} > "$diagnosticsDir/resources-${phase}.log" 2>&1
}

collectSuite () {
	local suite=$1
	local composeFile=$2
	local containerIds
	containerIds=$(timeout --kill-after=5s 10s docker compose -f "$composeFile" ps --all --quiet) || return
	local containerId
	for containerId in $containerIds; do
		timeout --kill-after=5s 10s docker inspect \
			--format 'ID={{.Id}} Status={{.State.Status}} ExitCode={{.State.ExitCode}} OOMKilled={{.State.OOMKilled}}' \
			"$containerId" >> "$diagnosticsDir/${suite}-state.log" 2>&1 || true
	done
	timeout --kill-after=5s 10s docker compose -f "$composeFile" logs --no-color --timestamps \
		>> "$diagnosticsDir/${suite}-container.log" 2>&1 || true
}

case "$phase" in
	build)
		: "${BUILD_IMAGE_DOCKERFILE:?}" "${COMMANDBOX_VERSION:?}" "${BUILDX_BUILDER:?}"
		recordResources
		if [[ -n ${BASE_IMAGE_ARG:-} ]]; then
			timeout --kill-after=5s 30s docker buildx imagetools inspect "$BASE_IMAGE_ARG" \
				> "$diagnosticsDir/base-image.log" 2>&1 || true
		fi
		timeout --kill-after=30s 55m docker buildx build \
			--builder "$BUILDX_BUILDER" --platform linux/amd64 --load --pull --progress plain \
			--file "$BUILD_IMAGE_DOCKERFILE" \
			--build-arg COMMANDBOX_VERSION --build-arg BASE_IMAGE_ARG \
			--tag "$TEST_IMAGE" . 2>&1 | tee "$diagnosticsDir/build.log"
		docker image inspect --format 'ID={{.Id}} User={{.Config.User}}' "$TEST_IMAGE" \
			| tee "$diagnosticsDir/test-image.log"
		;;
	integration|secrets)
		composeFile=docker-compose.test.yml
		suiteTimeout=25m
		if [[ $phase == secrets ]]; then
			composeFile=docker-compose.secret-test.yml
			suiteTimeout=10m
		fi
		finishSuite () {
			local exitCode=$?
			trap - EXIT
			set +e
			collectSuite "$phase" "$composeFile"
			timeout --kill-after=5s 30s docker compose -f "$composeFile" down --volumes --remove-orphans \
				>> "$diagnosticsDir/${phase}-cleanup.log" 2>&1
			local cleanupCode=$?
			if [[ $exitCode == 0 ]]; then exitCode=$cleanupCode; fi
			exit "$exitCode"
		}
		trap finishSuite EXIT
		trap 'exit 130' INT
		trap 'exit 143' TERM
		timeout --kill-after=30s "$suiteTimeout" docker compose -f "$composeFile" \
			up --no-build --pull never --exit-code-from sut 2>&1 | tee "$diagnosticsDir/${phase}.log"
		;;
	diagnostics)
		recordResources
		collectSuite integration docker-compose.test.yml || true
		collectSuite secrets docker-compose.secret-test.yml || true
		builderIds=$(timeout --kill-after=5s 10s docker ps --filter name=buildx_buildkit --format '{{.ID}}')
		for builderId in $builderIds; do
			timeout --kill-after=5s 15s docker logs --timestamps "$builderId" \
				> "$diagnosticsDir/buildkit-${builderId}.log" 2>&1 || true
		done
		;;
	cleanup)
		cleanupCode=0
		for composeFile in docker-compose.test.yml docker-compose.secret-test.yml; do
			timeout --kill-after=5s 30s docker compose -f "$composeFile" down --volumes --remove-orphans \
				|| cleanupCode=$?
		done
		exit "$cleanupCode"
		;;
	*)
		printf 'Unknown release phase: %s\n' "$phase" >&2
		exit 2
		;;
esac