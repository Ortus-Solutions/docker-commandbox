#!/bin/bash
set -e

cd $TRAVIS_BUILD_DIR

echo "CWD: $PWD"
echo "Dockerfile: $TRAVIS_BUILD_DIR/${BUILD_IMAGE_DOCKERFILE}"

# Push Version into Images: $IMAGE_VERSION IS SET IN TRAVIS
sed -i -e "s/@version@/$IMAGE_VERSION/g" $TRAVIS_BUILD_DIR/${BUILD_IMAGE_DOCKERFILE}

# Build our deployment image fresh so that no artifacts remain
docker build --no-cache -t ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} -f $TRAVIS_BUILD_DIR/${BUILD_IMAGE_DOCKERFILE} $TRAVIS_BUILD_DIR/
echo "INFO: Docker image successfully built"

# Log in to Docker Hub
docker login -u $DOCKER_HUB_USERNAME -p "${DOCKER_HUB_PASSWORD}"
echo "INFO: Successfully logged in to Docker Hub!"

# Tag our image with the build reference

# Tag Builds
if [[ $TRAVIS_TAG ]]; then
	
	# Strip the `v` from the start of the tag
	if [[ ${BUILD_IMAGE_TAG} == 'ortussolutions/commandbox:amd64' ]]; then
		BUILD_IMAGE_TAG="${BUILD_IMAGE_TAG}:${TRAVIS_TAG#v}"
	else
		BUILD_IMAGE_TAG="${BUILD_IMAGE_TAG}-${TRAVIS_TAG#v}"
	fi

elif [[ $TRAVIS_BRANCH == 'development' ]]; then
	# Snapshot builds
	BUILD_IMAGE_TAG="${BUILD_IMAGE_TAG}-snapshot"
fi

	
docker tag ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} ${BUILD_IMAGE_TAG}

# Push our new image and tags to the registry
echo "INFO: Pushing new image to registry ${BUILD_IMAGE_TAG}"
docker push ${BUILD_IMAGE_TAG}

echo "INFO: Image ${BUILD_IMAGE_TAG} successfully published"

# Multi-arch build manifests
if [[ ${ARCH} == "x86_64" ]] && [[ "${BUILD_IMAGE_TAG}" =~ .*"amd64".*  ]]; then
	if  [[ $TRAVIS_BRANCH == 'master' ]] && [[ ${BUILD_IMAGE_TAG} == "ortussolutions/commandbox:amd64"  ]]; then
		PRIMARY_NAME="ortussolutions/commandbox:latest"
	else
		PRIMARY_NAME=${BUILD_IMAGE_TAG/amd64-/''}
	fi
	docker manifest create \
		$PRIMARY_NAME \
		--amend ${BUILD_IMAGE_TAG} \
		--amend ${BUILD_IMAGE_TAG/amd64/arm64}

	echo "INFO: Pushing primary manfiest to registry for ${PRIMARY_NAME}"
	docker manifest push $PRIMARY_NAME

	# Now create any suppplimentary manifests
	if [[ ! $TRAVIS_TAG ]] && [[ ${BUILD_IMAGE_TAG} == 'ortussolutions/commandbox:amd64' ]] && [[ $TRAVIS_BRANCH == 'master' ]]; then
		SUPPLEMENTAL_NAME=${BUILD_IMAGE_TAG/amd64/''}commandbox-${COMMANDBOX_VERSION}

		docker manifest create \
			$SUPPLEMENTAL_NAME \
			--amend ${BUILD_IMAGE_TAG} \
			--amend ${BUILD_IMAGE_TAG/amd64/arm64}

		echo "INFO: Pushing supplemental manfiest to registry ${SUPPLEMENTAL_NAME}"
		docker manifest push $SUPPLEMENTAL_NAME
	fi


fi
