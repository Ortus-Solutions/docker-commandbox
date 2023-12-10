# syntax = edrevo/dockerfile-plus
INCLUDE+ builds/base/Alpine.Dockerfile

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

ENV BOX_SERVER_APP_CFENGINE lucee@6.0.0+585

ENV LUCEE_EXTENSIONS D062D72F-F8A2-46F0-8CBC91325B2F067B;version=6.3.2

# WARM UP THE SERVER - we skip the declaration so that the default installed Lucee server will be used
RUN ${BUILD_DIR}/util/warmup-server.sh