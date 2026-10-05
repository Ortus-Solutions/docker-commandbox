#!/bin/bash
set -euo pipefail

repoDir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
testDir=$(mktemp -d)
trap 'rm -rf "$testDir"' EXIT
export RELEASE_DIAGNOSTICS_DIR="$testDir/diagnostics"
export MOCK_CALLS="$testDir/calls"
export COMPOSE_PROJECT_NAME=release-unit-test
export TEST_IMAGE=release-unit-test:latest
export BUILD_IMAGE_DOCKERFILE=builds/base/Dockerfile
export COMMANDBOX_VERSION=test
export BUILDX_BUILDER=test-builder
export BASE_IMAGE_ARG=example/base:test
export MOCK_EXIT_CODE=0
export MOCK_CLEANUP_CODE=0
export MOCK_TIMEOUT_CODE=0

docker () {
	printf '%s\n' "$*" >> "$MOCK_CALLS"
	case "$*" in
		*' up --no-build '*)
			printf 'Test output\n'
			return "$MOCK_EXIT_CODE"
			;;
		*' down --volumes --remove-orphans') return "$MOCK_CLEANUP_CODE" ;;
		*' ps --all --quiet') printf 'test-container\n' ;;
		'ps --filter name=buildx_buildkit '*) printf 'test-builder\n' ;;
		'buildx build '*) return "$MOCK_EXIT_CODE" ;;
		'inspect '*) printf 'Status=exited ExitCode=%s OOMKilled=false\n' "$MOCK_EXIT_CODE" ;;
		*) printf 'Mock Docker output\n' ;;
	esac
}

timeout () {
	printf 'timeout %s\n' "$*" >> "$MOCK_CALLS"
	shift 2
	if [[ $MOCK_TIMEOUT_CODE != 0 && "$*" == *' up --no-build '* ]]; then
		return "$MOCK_TIMEOUT_CODE"
	fi
	"$@"
}
export -f docker timeout

runPhase () {
	local phase=$1
	local expectedCode=$2
	local exitCode=0
	bash "$repoDir/build/test-release.sh" "$phase" > "$testDir/output" 2>&1 || exitCode=$?
	if [[ $exitCode != "$expectedCode" ]]; then
		printf '%s returned %s, expected %s\n' "$phase" "$exitCode" "$expectedCode" >&2
		cat "$testDir/output" >&2
		exit 1
	fi
}

runPhase build 0
grep -q 'buildx imagetools inspect example/base:test' "$MOCK_CALLS"
grep -q 'buildx build --builder test-builder --platform linux/amd64 --load --pull --progress plain' "$MOCK_CALLS"
[[ -s $RELEASE_DIAGNOSTICS_DIR/base-image.log ]]

runPhase integration 0
runPhase secrets 0
grep -q 'docker-compose.test.yml up --no-build --pull never --exit-code-from sut' "$MOCK_CALLS"
grep -q 'docker-compose.secret-test.yml up --no-build --pull never --exit-code-from sut' "$MOCK_CALLS"
grep -q 'docker-compose.test.yml down --volumes --remove-orphans' "$MOCK_CALLS"
grep -q 'docker-compose.secret-test.yml down --volumes --remove-orphans' "$MOCK_CALLS"

export MOCK_EXIT_CODE=17
runPhase integration 17
grep -q 'Test output' "$RELEASE_DIAGNOSTICS_DIR/integration.log"
grep -q 'ExitCode=17' "$RELEASE_DIAGNOSTICS_DIR/integration-state.log"
export MOCK_CLEANUP_CODE=9
runPhase secrets 17
runPhase build 17

export MOCK_EXIT_CODE=0
runPhase integration 9
runPhase cleanup 9
export MOCK_CLEANUP_CODE=0
export MOCK_TIMEOUT_CODE=124
runPhase integration 124
grep -q 'timeout --kill-after=30s 25m' "$MOCK_CALLS"
grep -q 'timeout --kill-after=30s 10m' "$MOCK_CALLS"
export MOCK_TIMEOUT_CODE=0

runPhase diagnostics 0
grep -q 'ExitCode=17' "$RELEASE_DIAGNOSTICS_DIR/integration-state.log"
[[ -s $RELEASE_DIAGNOSTICS_DIR/buildkit-test-builder.log ]]
runPhase cleanup 0
runPhase invalid 2
printf 'Release orchestration checks passed\n'