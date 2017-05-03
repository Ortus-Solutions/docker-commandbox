#!/bin/bash
set -e

# Build Base Image
docker build --no-cache -t ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} -f ./${BUILD_IMAGE_DOCKERFILE} ./
echo "INFO: Docker image successfully built"

# Log in to Docker Hub
docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD
echo "INFO: Successfully logged in to Docker Hub!"

# Tag our image with the build reference
# Add :latest tag, if applicable
if [[ ${BUILD_IMAGE_TAG} == 'ortussolutions/commandbox' ]] && [[ $TRAVIS_BRANCH == 'master' ]]; then
	docker tag ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} ${BUILD_IMAGE_TAG}
	docker tag ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} ${BUILD_IMAGE_TAG}:${COMMANDBOX_VERSION}
    docker tag ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} ${BUILD_IMAGE_TAG}:latest
else

	if [[ ${BUILD_IMAGE_TAG} == 'ortussolutions/commandbox' ]] && [[ $TRAVIS_BRANCH == 'development' ]]; then
		BUILD_IMAGE_TAG="${BUILD_IMAGE_TAG}:snapshot"
	elif [[ $TRAVIS_BRANCH == 'development' ]]; then
		BUILD_IMAGE_TAG="${BUILD_IMAGE_TAG}-snapshot"
	fi

	docker tag ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} ${BUILD_IMAGE_TAG}
fi

# Push our new image and tags to the registry
echo "INFO: Pushing new image to registry ${BUILD_IMAGE_TAG}"
docker push ${BUILD_IMAGE_TAG}


if [[ ${BUILD_IMAGE_TAG} == 'ortussolutions/commandbox' ]] && [[ $TRAVIS_BRANCH == 'master' ]]; then
    docker push ${BUILD_IMAGE_TAG}:latest
    docker push ${BUILD_IMAGE_TAG}:${COMMANDBOX_VERSION}
fi

echo "INFO: Image ${BUILD_IMAGE_TAG} successfully published"