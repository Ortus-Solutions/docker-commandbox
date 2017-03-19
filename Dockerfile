FROM openjdk:8-jre

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

# Port Mappings
ENV PORT ${PORT:-8080}
ENV SSL_PORT ${SSL_PORT:-8443}
EXPOSE ${PORT} ${SSL_PORT}

# Directory Mappings
ENV APP_DIR /app
ENV BUILD_DIR $HOME/build
ENV BIN_DIR /usr/bin
WORKDIR ${APP_DIR}
RUN mkdir $HOME/build
COPY ./test/ ${APP_DIR}/
COPY ./build/ ${BUILD_DIR}/
RUN ls -la ${BUILD_DIR}

RUN chmod +x ${BUILD_DIR}/dependencies.sh
RUN chmod +x ${BUILD_DIR}/run.sh
RUN ${BUILD_DIR}/dependencies.sh

CMD $BUILD_DIR/run.sh
