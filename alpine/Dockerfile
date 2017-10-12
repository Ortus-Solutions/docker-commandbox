FROM frolvlad/alpine-oraclejdk8

LABEL version="@version@"
LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

# Since alpine runs as a single user, we need to create a "root" direcotry
ENV HOME /root

# Basic Dependencies
RUN apk update
RUN apk add curl jq bash

### Directory Mappings ###
# APP_DIR = the directory where the application runs
ENV APP_DIR /app
WORKDIR $APP_DIR

# BIN_DIR = Where the box binary goes
ENV BIN_DIR /usr/bin
WORKDIR $BIN_DIR

# BUILD_DIR = WHERE runtime scripts go
ENV BUILD_DIR $HOME/build
WORKDIR $BUILD_DIR

# Copy file system
COPY ./test/ ${APP_DIR}/
COPY ./build/ ${BUILD_DIR}/
RUN ls -la ${BUILD_DIR}
RUN chmod +x $BUILD_DIR/*.sh

# Commandbox Installation
RUN $BUILD_DIR/util/install-commandbox.sh

# CFConfig Installation
RUN $BUILD_DIR/util/install-cfconfig.sh

# Cleanup and Optimize our Installation
RUN ${BUILD_DIR}/util/optimize.sh

# Default Port Environment Variables
ENV PORT 8080
ENV SSL_PORT 8443

# Healthcheck environment variables
ENV HEALTHCHECK_URI "http://127.0.0.1:${PORT}/"

# Our healthcheck interval doesn't allow dynamic intervals - Default is 20s intervals with 15 retries
HEALTHCHECK --interval=20s --timeout=30s --retries=15 CMD curl --fail ${HEALTHCHECK_URI} || exit 1

EXPOSE ${PORT} ${SSL_PORT}

CMD $BUILD_DIR/run.sh