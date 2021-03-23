FROM commandbox-base

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

#Hard Code our engine environment
ENV CFENGINE adobe@2021.0.1+325996

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh