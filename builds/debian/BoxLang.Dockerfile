# syntax = edrevo/dockerfile-plus
INCLUDE+ builds/base/JDK21.Dockerfile

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

RUN box install commandbox-boxlang

ENV BOX_SERVER_APP_CFENGINE boxlang@1.0.0-beta23+27

RUN ${BUILD_DIR}/util/warmup-server.sh
