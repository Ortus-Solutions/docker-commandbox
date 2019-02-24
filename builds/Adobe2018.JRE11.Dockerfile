FROM commandbox-base

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

#Hard Code our engine environment
ENV CFENGINE adobe@2018
ENV SERVER_JRE openjdk11
# We need to clear this variable that AdoptOpenJDK sets for 8, which is not available in 11
ENV JAVA_TOOL_OPTIONS ""
# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh