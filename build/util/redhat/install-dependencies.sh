#!/bin/sh
set -e

microdnf upgrade -y \
			--refresh \
			--best \
			--nodocs \
			--noplugins \
			--setopt=install_weak_deps=0

for package in gnupg2 wget; do
	if rpm -q "$package" >/dev/null 2>&1; then
		microdnf remove -y "$package"
	fi
done

microdnf install -y \
				--setopt=install_weak_deps=0 \
				shadow-utils \
                jq \
                zip \
                unzip \
                fontconfig

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
{ \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(command -v javac || command -v java)")")"'; \
	} > "$BIN_DIR/docker-java-home"

chmod 755 "$BIN_DIR/docker-java-home"

# Cleanup before the layer is committed
microdnf clean all