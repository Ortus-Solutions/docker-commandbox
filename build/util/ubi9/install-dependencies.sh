#!/bin/sh
set -e

microdnf upgrade -y \
			--refresh \
			--best \
			--nodocs \
			--noplugins \
			--setopt=install_weak_deps=0

microdnf install -y \
                jq \
                procps \
                which \
                wget \
                bzip2 \
                zip \
                unzip \
                gnupg \
                readline \
                fontconfig

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
{ \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home

# Ensure all runwar users have permission on the java home
chown -R $(whoami):${WORKGROUP} /usr/local/bin/docker-java-home
chmod g+x /usr/local/bin/docker-java-home

# Ensure all runwar users have permission on the build scripts
chown -R $(whoami):${WORKGROUP} $BUILD_DIR

# Cleanup before the layer is committed
microdnf clean all