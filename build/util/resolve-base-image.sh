#!/bin/bash
set -euo pipefail

# Resolve a mutable base image reference to its version-pinned (or snapshot) form.
#
# Environment inputs:
#   BASE_IMAGE    e.g. ortussolutions/commandbox:latest
#   GITHUB_REF    git ref (refs/heads/main or refs/heads/development)
#   IMAGE_VERSION image version read from version.json
#
# Output: the resolved base image reference (no trailing newline).

: "${BASE_IMAGE:?}" "${GITHUB_REF:?}" "${IMAGE_VERSION:?}"

BASE_TAG="${BASE_IMAGE#*:}"
if [[ $GITHUB_REF == 'refs/heads/development' ]]; then
	printf '%s:%s-snapshot' "${BASE_IMAGE%:*}" "$BASE_TAG"
elif [[ $BASE_TAG == 'latest' ]]; then
	printf '%s:%s' "${BASE_IMAGE%:*}" "$IMAGE_VERSION"
else
	printf '%s:%s-%s' "${BASE_IMAGE%:*}" "$BASE_TAG" "$IMAGE_VERSION"
fi
