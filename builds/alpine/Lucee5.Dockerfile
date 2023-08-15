# syntax = edrevo/dockerfile-plus
INCLUDE+ builds/base/Alpine.Dockerfile

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

ENV BOX_SERVER_APP_CFENGINE lucee@5.3.12+1

# WARM UP THE SERVER - we skip the declaration so that the default installed Lucee server will be used
RUN ${BUILD_DIR}/util/warmup-server.sh