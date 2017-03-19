FROM openjdk:8-jre

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

ENV PORT ${PORT:-8080}
ENV SSL_PORT ${SSL_PORT:-8443}
EXPOSE ${PORT} ${SSL_PORT}

RUN mkdir ~/tmp
RUN mkdir ~/build
ENV APP_DIR /app
ENV BUILD_DIR ~/build
ENV BIN_DIR /usr/bin
COPY ./build/ ${BUILD_DIR}/
RUN ls -la ${BUILD_DIR}

RUN chmod +x ${BUILD_DIR}/dependencies.sh
RUN chmod +x ${BUILD_DIR}/run.sh
RUN ${BUILD_DIR}/dependencies.sh

COPY ./test/ ${APP_DIR}/
WORKDIR ${APP_DIR}

CMD $BUILD_DIR/run.sh