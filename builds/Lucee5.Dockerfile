FROM commandbox-base

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

ENV CFENGINE lucee@5.3.7+48

# WARM UP THE SERVER - we skip the declaration so that the default installed Lucee server will be used
RUN ${BUILD_DIR}/util/warmup-server.sh