# syntax = docker/dockerfile:1
ARG BASE_IMAGE_ARG
FROM ${BASE_IMAGE_ARG}

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

#Hard Code our engine environment
ENV BOX_SERVER_APP_CFENGINE adobe@2021.0.23+330486

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh