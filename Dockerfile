FROM openjdk:8-jre

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

# Port Mappings
ENV PORT ${PORT:-8080}
ENV SSL_PORT ${SSL_PORT:-8443}
EXPOSE ${PORT} ${SSL_PORT}

# Directory Mappings
ENV BUILD_DIR /app
ENV BIN_DIR /usr/bin

# Copy assets into the build directory
COPY ./ ${BUILD_DIR}/
# Set working directory for docker
WORKDIR ${BUILD_DIR}

# Install CommandBox
RUN mkdir ~/tmp
RUN echo "Installing CommandBox"
RUN curl --location 'https://www.ortussolutions.com/parent/download/commandbox/type/bin' -o /tmp/box.zip
RUN unzip /tmp/box.zip -d ${BIN_DIR}
RUN chmod +x ${BIN_DIR}/box

# Echo installed version
RUN COMMANDBOX_VERSION="$(box version)"
RUN echo "$COMMANDBOX_VERSION successfully installed"

CMD cd $BUILD_DIR && \
	# Setup basics from env variables and port binding to container
	box server set web.host=0.0.0.0 openbrowser=false web.http.port=${PORT} web.ssl.port=${SSL_PORT} && \
	# Start the server
	box server start && \
	# We sleep due to ACF lazyness
	sleep 10 && \
	# Tail the server output
	tail -f $( echo $(box server info property=consoleLogPath) | xargs )
