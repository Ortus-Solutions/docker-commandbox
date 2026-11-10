#!/bin/bash
set -euo pipefail

# Compute the final Docker image tags for a build entry.
#
# Environment inputs:
#   BUILD_IMAGE_TAGS  comma-separated tag list (e.g. "latest,jre21")
#   GITHUB_REF        git ref (refs/heads/main or refs/heads/development)
#   IMAGE_VERSION     image version read from version.json
#   DOCKER_IMAGE      repository name (e.g. ortussolutions/commandbox)
#
# Output: one full tag per line (e.g. ortussolutions/commandbox:latest).

: "${BUILD_IMAGE_TAGS:?}" "${GITHUB_REF:?}" "${IMAGE_VERSION:?}" "${DOCKER_IMAGE:?}"

IFS=',' read -ra TAG_ARRAY <<< "$BUILD_IMAGE_TAGS"

for tag in "${TAG_ARRAY[@]}"; do
	if [[ $GITHUB_REF == 'refs/heads/development' ]]; then
		printf '%s:%s-snapshot\n' "$DOCKER_IMAGE" "$tag"
	else
		printf '%s:%s\n' "$DOCKER_IMAGE" "$tag"
		if [[ $tag == 'latest' ]]; then
			printf '%s:%s\n' "$DOCKER_IMAGE" "$IMAGE_VERSION"
		else
			printf '%s:%s-%s\n' "$DOCKER_IMAGE" "$tag" "$IMAGE_VERSION"
		fi
	fi
done
