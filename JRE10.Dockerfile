FROM buildpack-deps:sid-curl

LABEL version="@version@"
LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

ARG COMMANDBOX_VERSION
# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Since alpine runs as a single user, we need to create a "root" direcotry
ENV HOME /root

### Directory Mappings ###
# BIN_DIR = Where the box binary goes
ENV BIN_DIR /usr/local/bin
WORKDIR $BIN_DIR

# BUILD_DIR = WHERE runtime scripts go
ENV BUILD_DIR $HOME/build
WORKDIR $BUILD_DIR

# APP_DIR = the directory where the application runs
ENV APP_DIR /app
WORKDIR $APP_DIR

COPY ./builds/debian ${BUILD_DIR}/debian  

# Basic Dependencies
RUN ${BUILD_DIR}/debian/install-dependencies.sh
# Install JRE
# do some fancy footwork to create a JAVA_HOME that's cross-architecture-safe
RUN ln -svT "/usr/lib/jvm/java-10-openjdk-$(dpkg --print-architecture)" /docker-java-home
ENV JAVA_HOME /docker-java-home
ENV JAVA_VERSION 10.0.2
ENV JAVA_DEBIAN_VERSION 10.0.2+13-2

RUN set -ex; \
    \
    # deal with slim variants not having man page directories (which causes "update-alternatives" to fail)
    if [ ! -d /usr/share/man/man1 ]; then \
    mkdir -p /usr/share/man/man1; \
    fi; \
    \
    # ca-certificates-java does not support src:openjdk-10 yet:
    # /etc/ca-certificates/update.d/jks-keystore: 86: /etc/ca-certificates/update.d/jks-keystore: java: not found
    ln -svT /docker-java-home/bin/java /usr/local/bin/java; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    openjdk-10-jre="$JAVA_DEBIAN_VERSION" \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    \
    rm -v /usr/local/bin/java; \
    \
    # verify that "docker-java-home" returns what we expect
    [ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ]; \
    \
    # update-alternatives so that future installs of other OpenJDK versions don't change /usr/bin/java
    update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'; \
    # ... and verify that it actually worked for one of the alternatives we care about
    update-alternatives --query java | grep -q 'Status: manual' 

# Copy file system
COPY ./test/ ${APP_DIR}/
COPY ./build/ ${BUILD_DIR}/
RUN ls -la ${BUILD_DIR}
RUN chmod +x $BUILD_DIR/*.sh

# Commandbox Installation
RUN $BUILD_DIR/util/install-commandbox.sh

# CFConfig Installation
RUN $BUILD_DIR/util/install-cfconfig.sh

# CommandBox-DotEnv Installation - Removed from installation until dotenv is Java 10 compatible
# RUN $BUILD_DIR/util/install-dotenv.sh

# Default Port Environment Variables
ENV PORT 8080
ENV SSL_PORT 8443

# Healthcheck environment variables
ENV HEALTHCHECK_URI "http://127.0.0.1:${PORT}/"

# Our healthcheck interval doesn't allow dynamic intervals - Default is 20s intervals with 15 retries
HEALTHCHECK --interval=20s --timeout=30s --retries=15 CMD curl --fail ${HEALTHCHECK_URI} || exit 1

EXPOSE ${PORT} ${SSL_PORT}

CMD $BUILD_DIR/run.sh