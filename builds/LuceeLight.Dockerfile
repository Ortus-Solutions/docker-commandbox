FROM commandbox-base

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

#Hard Code our engine environment
ENV CFENGINE lucee-light

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh