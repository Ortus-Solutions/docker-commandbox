# syntax = edrevo/dockerfile-plus
INCLUDE+ builds/base/Dockerfile

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

#Hard Code our engine environment
ENV BOX_SERVER_APP_CFENGINE lucee-light@5

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh