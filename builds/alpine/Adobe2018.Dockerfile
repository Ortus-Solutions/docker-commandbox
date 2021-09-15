# syntax = edrevo/dockerfile-plus
INCLUDE+ builds/base/Alpine.Dockerfile

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

#Hard Code our engine environment
ENV BOX_SERVER_APP_CFENGINE adobe@2018.0.12+328566

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh