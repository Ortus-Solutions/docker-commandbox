FROM ortussolutions/commandbox:3.6.0-snapshot

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

# Copy Contentbox-specific Files
COPY ./resources/contentbox/ ${BUILD_DIR}/
RUN ls -la ${BUILD_DIR}

RUN chmod +x ${BUILD_DIR}/dependencies.sh
RUN chmod +x ${BUILD_DIR}/run-contentbox.sh
RUN ${BUILD_DIR}/dependencies.sh

CMD $BUILD_DIR/run-contentbox.sh
