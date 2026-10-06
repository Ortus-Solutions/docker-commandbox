FROM eclipse-temurin:21-jdk-ubi10-minimal

ARG COMMANDBOX_VERSION

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

# Default to UTF-8 file.encoding
ENV LANG=C.UTF-8

ENV HOME=/home/commandbox

# Shared runtime group
ENV WORKGROUP=runwar

### Directory Mappings ###
# BIN_DIR = Where the box binary goes
ENV BIN_DIR=/opt/bin
ENV BOXLANG_INSTALL_HOME=/opt/boxlang
ENV PATH="${BIN_DIR}:${BOXLANG_INSTALL_HOME}/bin:${PATH}"
# LIB_DIR = Where the build files go
ENV LIB_DIR=/opt/lib
WORKDIR $BIN_DIR

# BUILD_DIR = WHERE runtime scripts go
ENV BUILD_DIR=/opt/build
WORKDIR $BUILD_DIR

# COMMANDBOX_HOME = Where CommmandBox Lives
ENV COMMANDBOX_HOME=/opt/commandbox
ENV STARTUP_DIR=$COMMANDBOX_HOME/run

# BOXLANG HOME = Where BoxLang Lives
ENV BOXLANG_HOME=/opt/boxlang
RUN mkdir -p "$COMMANDBOX_HOME" "$BOXLANG_HOME" "$LIB_DIR/serverHome" "$HOME" "$STARTUP_DIR"

# APP_DIR = the directory where the application runs
ENV APP_DIR=/srv/app
WORKDIR $APP_DIR

# Copy file system
COPY ./test/ ${APP_DIR}/
COPY ./build/ ${BUILD_DIR}/
RUN chmod +x $BUILD_DIR/*.sh

# Basic Dependencies
RUN rm -rf $BUILD_DIR/util/alpine
RUN rm -rf $BUILD_DIR/util/debian

RUN ${BUILD_DIR}/util/redhat/install-dependencies.sh

# Commandbox Installation
RUN $BUILD_DIR/util/install-commandbox.sh
RUN bash "$BUILD_DIR/util/prepare-runtime.sh"

# Add our custom classes added in the previous step to the java classpath
ENV CLASSPATH="$LIB_DIR/java/classes"

# Default Port Environment Variables
ENV PORT=8080
ENV SSL_PORT=8443


# Healthcheck environment variables
ENV HEALTHCHECK_URI="http://127.0.0.1:${PORT}/"

# Our healthcheck interval doesn't allow dynamic intervals - Default is 20s intervals with 15 retries
HEALTHCHECK --interval=20s --timeout=30s --retries=15 CMD curl --fail ${HEALTHCHECK_URI} || exit 1

EXPOSE ${PORT} ${SSL_PORT}

USER commandbox:runwar
CMD $BUILD_DIR/run.sh
