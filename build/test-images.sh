#!/bin/bash
set -e

export TEST_IMAGE=${TEST_IMAGE:-docker-commandbox-sut:latest}
export COMPOSE_PROJECT_NAME=${COMPOSE_PROJECT_NAME:-commandbox-tests-$$}
composeArgs=( -f docker-compose.test.yml )
cleanup () {
	docker compose "${composeArgs[@]}" down --volumes --remove-orphans
}
trap cleanup EXIT

docker compose "${composeArgs[@]}" build
[[ $(docker image inspect --format '{{.Config.User}}' "$TEST_IMAGE") = commandbox:runwar ]]

for identity in default 1002:1000 1002:1002; do
	for composeFile in docker-compose.test.yml docker-compose.secret-test.yml; do
		composeArgs=( -f "$composeFile" )
		if [[ $identity != default ]]; then
			export TEST_USER=$identity
			composeArgs+=( -f docker-compose.user-test.yml )
		fi
		docker compose "${composeArgs[@]}" up --no-build --exit-code-from sut
		cleanup
	done
done

bash build/test-runtime.sh "$TEST_IMAGE"