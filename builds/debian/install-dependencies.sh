#!/bin/bash

apt-get update && apt-get \install --assume-yes \
                                apt-utils \
                                ca-certificates \
                                curl \
                                jq \
                                curl \
                                bzip2 \
                                unzip \
                                fontconfig

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
{ \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home

chmod +x /usr/local/bin/docker-java-home

# Cleanup before the layer is committed
apt-get clean autoclean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/*
