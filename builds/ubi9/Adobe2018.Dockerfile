# syntax = edrevo/dockerfile-plus
INCLUDE+ builds/base/ubi9.JDK11.Dockerfile

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

#Hard Code our engine environment
ENV BOX_SERVER_APP_CFENGINE adobe@2018.0.18+330145

ENV JAVA_TOOL_OPTIONS '-Djdk.serialFilter=!org.mozilla.**;!com.sun.syndication.**;!org.apache.commons.beanutils.**;!org.jgroups.**'

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh