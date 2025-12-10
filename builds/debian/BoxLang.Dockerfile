# syntax = docker/dockerfile:1
ARG BASE_IMAGE_ARG
FROM ${BASE_IMAGE_ARG}

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"


ENV BOX_SERVER_APP_CFENGINE boxlang@1.8.0

RUN ${BUILD_DIR}/util/warmup-server.sh
