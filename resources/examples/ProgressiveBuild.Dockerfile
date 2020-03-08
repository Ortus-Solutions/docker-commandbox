FROM ortussolutions/commandbox:lucee5-snapshot as workbench

# Generate the startup script only
ENV FINALIZE_STARTUP true
RUN $BUILD_DIR/run.sh

FROM adoptopenjdk/openjdk11:slim as app

# COPY our generated files
COPY --from=workbench /app /app
COPY --from=workbench /usr/local/lib/serverHome /usr/local/lib/serverHome
RUN mkdir -p /usr/local/lib/CommandBox/lib
# We have to copy this file over because otherwise an error on the tray options is thrown
COPY --from=workbench /usr/local/lib/CommandBox/server /usr/local/lib/CommandBox/server
COPY --from=workbench /usr/local/lib/CommandBox/lib/runwar-4.0.5.jar /usr/local/lib/CommandBox/lib/runwar-4.0.5.jar
COPY --from=workbench /usr/local/bin/startup-final.sh /usr/local/bin/run.sh

CMD /usr/local/bin/run.sh