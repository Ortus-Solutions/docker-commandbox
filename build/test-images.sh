#!/bin/bash
set -e

export TEST_IMAGE=${TEST_IMAGE:-docker-commandbox-sut:latest}
export COMPOSE_PROJECT_NAME=${COMPOSE_PROJECT_NAME:-commandbox-tests-$$}
testSuite=${TEST_SUITE:-full}

if [[ $testSuite == engine ]]; then
	export TEST_COMMAND=/opt/build/test-engine.sh
else
	export TEST_COMMAND=${TEST_COMMAND:-/opt/build/test.sh}
fi

composeArgs=( -f docker-compose.test.yml )
cleanup () {
	docker compose "${composeArgs[@]}" down --volumes --remove-orphans
}
trap cleanup EXIT

docker compose "${composeArgs[@]}" build
[[ $(docker image inspect --format '{{.Config.User}}' "$TEST_IMAGE") = commandbox:runwar ]]

for identity in default 1002:1000 1002:1002 root; do
	for composeFile in docker-compose.test.yml docker-compose.secret-test.yml; do
		if [[ $testSuite == engine && $composeFile == docker-compose.secret-test.yml ]]; then
			continue
		fi
		composeArgs=( -f "$composeFile" )
		if [[ $identity != default ]]; then
			export TEST_USER=$identity
			export TEST_EXPECTED_UID=1002
			if [[ $identity = root ]]; then
				export TEST_EXPECTED_UID=0
			fi
			composeArgs+=( -f docker-compose.user-test.yml )
		fi
		docker compose "${composeArgs[@]}" up --no-build --exit-code-from sut
		cleanup
	done
done

if [[ $testSuite == full ]]; then
	bash build/test-runtime.sh "$TEST_IMAGE"
fi