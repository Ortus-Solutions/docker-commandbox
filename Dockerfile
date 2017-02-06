FROM openjdk:8-jre

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

RUN mkdir ~/tmp
ENV PORT ${PORT:-8080}
ENV SSL_PORT ${SSL_PORT:-8443}
EXPOSE ${PORT} ${SSL_PORT}
ENV BUILD_DIR /app
ENV BIN_DIR /usr/bin
COPY ./ ${BUILD_DIR}/

WORKDIR ${BUILD_DIR}

RUN echo "Installing CommandBox"

RUN curl --location 'https://www.ortussolutions.com/parent/download/commandbox/type/bin' -o /tmp/box.zip
RUN unzip /tmp/box.zip -d ${BIN_DIR}
RUN chmod +x ${BIN_DIR}/box

RUN COMMANDBOX_VERSION="$(box version)"

RUN echo "$COMMANDBOX_VERSION successfully installed"

#ENV LOGFILE_PATH = $( echo ${$BIN_DIR/box server info property=consoleLogPath} | xargs )

CMD cd $BUILD_DIR && \
	box server set web.host=0.0.0.0 openbrowser=false web.http.port=${PORT} web.ssl.port=${SSL_PORT} && \
	box server start --console 
