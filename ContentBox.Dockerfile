FROM ortussolutions/commandbox:latest

LABEL version="@version@"
LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

COPY ./resources/contentbox/ ${APP_DIR}/
COPY ./resources/contentbox-dependencies.sh ${BUILD_DIR}/
COPY ./resources/run-contentbox.sh ${BUILD_DIR}/

# Move our executables to the build directory
RUN chmod +x ${BUILD_DIR}/contentbox-dependencies.sh
RUN chmod +x ${BUILD_DIR}/run-contentbox.sh

RUN ls -la ${BUILD_DIR}

RUN ${BUILD_DIR}/contentbox-dependencies.sh

# Override our default healthcheck URI so the first CFML request doesn't load Coldbox and serves a static file
ENV HEALTHCHECK_URI "http://127.0.0.1:${PORT}/robots.txt"

CMD ${BUILD_DIR}/run-contentbox.sh
