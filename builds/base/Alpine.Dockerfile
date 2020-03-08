FROM adoptopenjdk/openjdk8:alpine-slim

LABEL version "@version@"
LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

ARG COMMANDBOX_VERSION

# Since alpine runs as a single user, we need to create a "root" direcotry
ENV HOME /root

# Alpine workgroup is the same
ENV WORKGROUP root

# Flag as an alpine build
RUN touch /etc/alpine-release

# Basic Dependencies including binaries for PDF rendering
RUN apk update && apk add curl \
                        jq \
                        bash \
                        openssl \
                        libgcc \
                        libstdc++ \
                        libx11 \
                        glib \
                        libxrender \
                        libxext \
                        libintl \
                        shadow \
                        fontconfig \
                        && rm -f /var/cache/apk/*

### Directory Mappings ###
# BIN_DIR = Where the box binary goes
ENV BIN_DIR /usr/bin
# LIB_DIR = Where the build files go
ENV LIB_DIR /usr/lib
WORKDIR $BIN_DIR

# COMMANDBOX_HOME = Where CommmandBox Lives
ENV COMMANDBOX_HOME=$LIB_DIR/CommandBox

# APP_DIR = the directory where the application runs
ENV APP_DIR /app
WORKDIR $APP_DIR

# BUILD_DIR = WHERE runtime scripts go
ENV BUILD_DIR $LIB_DIR/build
WORKDIR $BUILD_DIR

# Copy file system
COPY ./test/ ${APP_DIR}/
COPY ./build/ ${BUILD_DIR}/
RUN chmod +x $BUILD_DIR/*.sh

# Ensure all workgroup users have permission on the build scripts
RUN chown -R nobody:${WORKGROUP} $BUILD_DIR

# Commandbox Installation
RUN $BUILD_DIR/util/install-commandbox.sh

# CFConfig Installation
RUN $BUILD_DIR/util/install-cfconfig.sh

# CommandBox-DotEnv Installation
RUN $BUILD_DIR/util/install-dotenv.sh

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
