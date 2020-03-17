FROM ortussolutions/commandbox:lucee5-snapshot as workbench

# Generate the startup script only
ENV FINALIZE_STARTUP true
RUN $BUILD_DIR/run.sh

# Debian Slim is the smallest OpenJDK image on that kernel. For most apps, this should work to run your applications
FROM adoptopenjdk/openjdk11:debianslim-jre as app

# COPY our generated files
COPY --from=workbench /app /app
COPY --from=workbench /usr/local/lib/serverHome /usr/local/lib/serverHome

RUN mkdir -p /usr/local/lib/CommandBox/lib

COPY --from=workbench /usr/local/lib/CommandBox/lib/runwar-4.0.5.jar /usr/local/lib/CommandBox/lib/runwar-4.0.5.jar
COPY --from=workbench /usr/local/bin/startup-final.sh /usr/local/bin/run.sh

CMD /usr/local/bin/run.sh