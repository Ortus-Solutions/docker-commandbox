# syntax = edrevo/dockerfile-plus
INCLUDE+ builds/base/JDK17.Dockerfile

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

#Hard Code our engine environment
ENV BOX_SERVER_APP_CFENGINE adobe@2023.0.1+330480

ENV JAVA_TOOL_OPTIONS '-Djdk.serialFilter=!org.mozilla.**;!com.sun.syndication.**;!org.apache.commons.beanutils.**;!org.jgroups.**'

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh