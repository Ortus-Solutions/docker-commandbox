ARG VERSION
ARG COMMANDBOX_VERSION
ARG ARCH

FROM adoptopenjdk/openjdk11:${ARCH}-debianslim-jdk-11.0.10_9-slim
LABEL version ${VERSION}
LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

ENV COMMANDBOX_VERSION=$COMMANDBOX_VERSION

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Since alpine runs as a single user, we need to create a "root" direcotry
ENV HOME /root

# Add a working group which any dynamic users can be assigned
ENV WORKGROUP runwar
RUN groupadd $WORKGROUP && usermod -a -G $WORKGROUP root

### Directory Mappings ###
# BIN_DIR = Where the box binary goes
ENV BIN_DIR /usr/local/bin
# LIB_DIR = Where the build files go
ENV LIB_DIR /usr/local/lib
WORKDIR $BIN_DIR

# BUILD_DIR = WHERE runtime scripts go
ENV BUILD_DIR $LIB_DIR/build
WORKDIR $BUILD_DIR

# COMMANDBOX_HOME = Where CommmandBox Lives
ENV COMMANDBOX_HOME=$LIB_DIR/CommandBox

# APP_DIR = the directory where the application runs
ENV APP_DIR /app
WORKDIR $APP_DIR

# Copy file system
COPY ./test/ ${APP_DIR}/
COPY ./build/ ${BUILD_DIR}/
RUN chmod +x $BUILD_DIR/*.sh

# Ensure all runwar users have permission on the build scripts
RUN chown -R $(whoami):${WORKGROUP} $BUILD_DIR

# Switch out our java.security file to disable TLS and increase key size
RUN rm -rf /opt/java/openjdk/conf/security/java.security && mv $BUILD_DIR/resources/java.security /opt/java/openjdk/conf/security/java.security

# Basic Dependencies
RUN rm -rf $BUILD_DIR/util/alpine
RUN ${BUILD_DIR}/util/debian/install-dependencies.sh

# Commandbox Installation
RUN $BUILD_DIR/util/install-commandbox.sh

# CFConfig Installation
RUN $BUILD_DIR/util/install-cfconfig.sh

# CommandBox-DotEnv Installation
RUN $BUILD_DIR/util/install-dotenv.sh

# Default Port Environment Variables
ENV PORT 8080
ENV SSL_PORT 8443

# Healthcheck environment variables
ENV HEALTHCHECK_URI "http://127.0.0.1:${PORT}/"

# Our healthcheck interval doesn't allow dynamic intervals - Default is 20s intervals with 15 retries
HEALTHCHECK --interval=20s --timeout=30s --retries=15 CMD curl --fail ${HEALTHCHECK_URI} || exit 1

EXPOSE ${PORT} ${SSL_PORT}

CMD $BUILD_DIR/run.sh
