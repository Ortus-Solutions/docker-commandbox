FROM ortussolutions/commandbox:latest

LABEL version="@version@"
LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL maintainer "Luis Majano <lmajano@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox/contentbox"

# Copy over our app resources and build scripts
COPY ./resources/app/ ${BUILD_DIR}/contentbox-app
COPY ./build/contentbox-dependencies.sh ${BUILD_DIR}/
COPY ./build/run-contentbox.sh ${BUILD_DIR}/

# Make them executable just in case.
RUN chmod +x ${BUILD_DIR}/contentbox-dependencies.sh
RUN chmod +x ${BUILD_DIR}/run-contentbox.sh

#debug
RUN ls -la ${BUILD_DIR}

# Install dependencies
RUN ${BUILD_DIR}/contentbox-dependencies.sh

# Override our default healthcheck URI so the first CFML request doesn't load Coldbox and serves a static file
ENV HEALTHCHECK_URI "http://127.0.0.1:${PORT}/robots.txt"

# Run The build
CMD ${BUILD_DIR}/run-contentbox.sh