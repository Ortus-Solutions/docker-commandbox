#!/bin/sh
set -e

apt-get update

# Upgrade all packages
apt-get -y upgrade

# TODO: Remove this manual update when the next Ubuntu version is released and test if CVEs are resolved
# Manually update specific packages with known CVE vulnerabilities to latest available versions
apt-get install -y \
    linux-libc-dev \
    libkrb5support0 \
    libkrb5-3 \
    libk5crypto3 \
    libgssapi-krb5-2

apt-get autoremove -y

apt-get install --assume-yes \
                                apt-utils \
                                ca-certificates \
                                curl \
                                jq \
                                bzip2 \
                                unzip \
                                gnupg \
                                libreadline-dev \
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
apt-get clean autoclean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/*
