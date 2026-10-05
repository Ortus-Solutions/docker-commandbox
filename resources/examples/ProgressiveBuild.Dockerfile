ARG BASE_IMAGE_ARG=ortussolutions/commandbox:boxlang
FROM ${BASE_IMAGE_ARG} as workbench

# Generate the startup script only
ENV FINALIZE_STARTUP=true
RUN $BUILD_DIR/run.sh && \
	mkdir -p /tmp/runtime && \
	cp --parents "$(jq -r '.runwarJarPath' "$LIB_DIR/serverHome/serverInfo.json")" /tmp/runtime

FROM eclipse-temurin:21-jre-noble as app

# COPY our generated files
COPY --from=workbench --chown=1000:1000 /srv/app /srv/app
COPY --from=workbench --chown=1000:1000 /opt/lib/serverHome /opt/lib/serverHome
COPY --from=workbench /tmp/runtime/ /
COPY --from=workbench --chown=1000:1000 /opt/commandbox/run /opt/commandbox/run
COPY --from=workbench /opt/build/util/prepare-runtime.sh /opt/build/util/prepare-runtime.sh
COPY --from=workbench /opt/build/util/log.sh /opt/build/util/log.sh

ENV APP_DIR=/srv/app
ENV HOME=/home/commandbox
ENV WORKGROUP=runwar
ENV BIN_DIR=/opt/bin
ENV BUILD_DIR=/opt/build
ENV LIB_DIR=/opt/lib
ENV COMMANDBOX_HOME=/opt/commandbox
ENV BOXLANG_HOME=/opt/boxlang
ENV BOXLANG_INSTALL_HOME=/opt/boxlang
ENV STARTUP_DIR=/opt/commandbox/run
RUN mkdir -p "$BIN_DIR" && bash "$BUILD_DIR/util/prepare-runtime.sh"
WORKDIR $APP_DIR

USER commandbox:runwar
CMD ["/bin/bash", "-c", "umask 0002; . \"$BUILD_DIR/util/log.sh\"; . \"$STARTUP_DIR/startup-final.env\"; exec \"$STARTUP_DIR/startup-final.sh\""]