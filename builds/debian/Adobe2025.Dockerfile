# syntax = edrevo/dockerfile-plus
INCLUDE+ builds/base/JDK17.Dockerfile

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

RUN box install --force commandbox-boxlang,commandbox-cfconfig

#Hard Code our engine environment
ENV BOX_SERVER_APP_CFENGINE adobe@2025.0.0+331385

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh