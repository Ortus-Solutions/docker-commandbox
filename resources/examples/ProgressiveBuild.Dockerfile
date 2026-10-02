ARG BASE_IMAGE_ARG=ortussolutions/commandbox:lucee6
FROM ${BASE_IMAGE_ARG} as workbench

# Generate the startup script only
ENV FINALIZE_STARTUP=true
RUN $BUILD_DIR/run.sh && \
	mkdir -p /tmp/runtime && \
	cp --parents "$(jq -r '.runwarJarPath' "$LIB_DIR/serverHome/serverInfo.json")" /tmp/runtime

FROM eclipse-temurin:21-jre-noble as app

# COPY our generated files
COPY --from=workbench /srv/app /srv/app
COPY --from=workbench /opt/lib/serverHome /opt/lib/serverHome
COPY --from=workbench /tmp/runtime/ /
COPY --from=workbench /opt/lib/java/classes /opt/lib/java/classes
COPY --from=workbench /opt/build/resources /opt/build/resources
COPY --from=workbench /opt/bin/startup-final.sh /opt/bin/run.sh

ENV APP_DIR=/srv/app
ENV CLASSPATH=/opt/lib/java/classes
ENV JAVA_TOOL_OPTIONS=-Djava.util.logging.config.file=/opt/build/resources/text.logging.properties
WORKDIR $APP_DIR

CMD ["/opt/bin/run.sh"]