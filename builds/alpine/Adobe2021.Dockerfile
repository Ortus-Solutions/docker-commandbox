# syntax = edrevo/dockerfile-plus
INCLUDE+ builds/base/Alpine.JDK11.Dockerfile

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

#Hard Code our engine environment
ENV BOX_SERVER_APP_CFENGINE adobe@2021.0.20+330407

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh