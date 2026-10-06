#!/bin/sh
set -e

apt-get update

# Upgrade all packages
apt-get -y upgrade

apt-get purge -y --auto-remove gnupg wget

apt-get install -y --no-install-recommends \
			ca-certificates \
			curl \
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

# Ensure all runwar users have permission on the java home
chmod 755 "$BIN_DIR/docker-java-home"

# Ensure all runwar users have permission on the build scripts

# Cleanup before the layer is committed
apt-get clean autoclean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/*
