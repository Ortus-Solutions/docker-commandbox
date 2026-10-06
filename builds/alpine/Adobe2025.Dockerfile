# syntax = docker/dockerfile:1
ARG BASE_IMAGE_ARG
FROM ${BASE_IMAGE_ARG}


LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

# Native libraries used by Adobe's PDF/CFDocument and image rendering
USER root
RUN apk add --no-cache libx11 libxrender libxext glib libintl
USER commandbox:runwar

#Hard Code our engine environment
ENV BOX_SERVER_APP_CFENGINE=adobe@2025.0.13+331960

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh