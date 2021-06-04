FROM commandbox-base

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

#Hard Code our engine environment
ENV BOX_SERVER_APP_CFENGINE lucee@5.2.9+31

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh