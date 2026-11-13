#!/bin/sh
set -e

apt-get update

# Upgrade all packages
apt-get -y upgrade

# Explicitly pull the latest coreutils revision to resolve the CVEs
# (CVE-2026-56391, CVE-2025-5278) reported against the version shipped
# in the upstream resolute base image.
# TODO: once the base image is updated, we may be able to remove this step
apt-get install -y --only-upgrade coreutils

apt-get purge -y --auto-remove gnupg wget

apt-get install -y --no-install-recommends \
			ca-certificates \
			curl \
			jq \
			zip \
			unzip \
			fontconfig

# Remove the pebble service manager shipped by the upstream resolute base
# image. It is not a dpkg-managed package and is unused by CommandBox, but
# its bundled Go stdlib is flagged by vulnerability scanners.
# TODO: once a patched version is available, we may be able to remove this removal
rm -f /usr/bin/pebble
rm -rf /var/lib/pebble

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
