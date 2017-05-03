#!/bin/bash

# Build Base Image
docker build --no-cache -t ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} -f ./${BUILD_IMAGE_DOCKERFILE} ./
echo "INFO: Docker image successfully built"

# Log in to Docker Hub
docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD
echo "INFO: Successfully logged in to Docker Hub!"

# Tag our image with the build reference and also as :latest
docker tag ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} ${BUILD_IMAGE_TAG}-${TRAVIS_COMMIT}
docker tag ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} ${BUILD_IMAGE_TAG}

if[[ ${BUILD_IMAGE_TAG} == 'ortussolutions/commandbox' ]]; then
    docker tag ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} ${BUILD_IMAGE_TAG}:latest
fi

# Push our new image and tags to the registry
echo "INFO: Pushing new image to registry ${BUILD_IMAGE_TAG}-${TRAVIS_COMMIT}"
docker push ${BUILD_IMAGE_TAG}


if[[ ${BUILD_IMAGE_TAG} == 'ortussolutions/commandbox' ]]; then
    docker push ${BUILD_IMAGE_TAG}:latest
fi

echo "INFO: Image ${BUILD_IMAGE_TAG} successfully published"