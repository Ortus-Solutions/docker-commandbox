# syntax = edrevo/dockerfile-plus
INCLUDE+ builds/base/JDK21.Dockerfile

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"


ENV BOX_SERVER_APP_CFENGINE boxlang@1.0.0-snapshot

RUN ${BUILD_DIR}/util/warmup-server.sh
