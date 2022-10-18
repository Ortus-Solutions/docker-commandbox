# syntax = edrevo/dockerfile-plus
INCLUDE+ builds/base/JDK8.Dockerfile

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

#Hard Code our engine environment
ENV BOX_SERVER_APP_CFENGINE adobe@11.0.19+314546

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh