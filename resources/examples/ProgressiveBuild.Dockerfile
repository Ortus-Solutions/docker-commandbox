ARG BASE_IMAGE_ARG=ortussolutions/commandbox:boxlang
FROM ${BASE_IMAGE_ARG} AS workbench

# Generate the startup script only
ENV FINALIZE_STARTUP=true
RUN "$BUILD_DIR/run.sh"

FROM eclipse-temurin:21-jre-noble AS app

# COPY our generated files
COPY --from=workbench --chown=1000:1000 /srv/app /srv/app
COPY --from=workbench --chown=1000:1000 /opt/lib/serverHome /opt/lib/serverHome
COPY --from=workbench --chown=1000:1000 /opt/boxlang /opt/boxlang
COPY --from=workbench --chown=1000:1000 /opt/commandbox/run/startup-final.sh /opt/commandbox/run/startup-final.sh
COPY --from=workbench --chown=1000:1000 /opt/commandbox/run/startup-final.env /opt/commandbox/run/startup-final.env

ENV APP_DIR=/srv/app
ENV HOME=/home/commandbox
ENV LIB_DIR=/opt/lib
ENV COMMANDBOX_HOME=/opt/commandbox
ENV BOXLANG_HOME=/opt/boxlang
ENV BOXLANG_INSTALL_HOME=/opt/boxlang
ENV STARTUP_DIR=/opt/commandbox/run
RUN groupmod -n runwar ubuntu && \
	usermod -l commandbox -d "$HOME" -g runwar -s /bin/bash ubuntu && \
	mkdir -p "$HOME" && \
	chown -R commandbox:runwar "$HOME" "$APP_DIR" "$LIB_DIR/serverHome" "$BOXLANG_HOME" "$COMMANDBOX_HOME" && \
	chmod -R ug+rwX,o-w "$HOME" "$APP_DIR" "$LIB_DIR/serverHome" "$BOXLANG_HOME" "$COMMANDBOX_HOME" && \
	find "$HOME" "$APP_DIR" "$LIB_DIR/serverHome" "$BOXLANG_HOME" "$COMMANDBOX_HOME" -type d -exec chmod g+s {} +
WORKDIR $APP_DIR

ENV HEALTHCHECK_URI=http://127.0.0.1:8080/
HEALTHCHECK --interval=20s --timeout=30s --retries=15 CMD curl --fail "$HEALTHCHECK_URI" || exit 1

USER commandbox:runwar
CMD ["/bin/bash", "-c", "umask 0002; . \"$STARTUP_DIR/startup-final.env\"; exec \"$STARTUP_DIR/startup-final.sh\""]