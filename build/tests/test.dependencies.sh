#!/bin/bash
set -euo pipefail

repoDir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
platform=${TEST_PLATFORM:-linux/amd64}
distros=( "${@}" )
if [[ ${#distros[@]} == 0 ]]; then distros=( debian alpine redhat ); fi

for distro in "${distros[@]}"; do
	case "$distro" in
		debian) suffix=noble ;;
		alpine) suffix=alpine ;;
		redhat) suffix=ubi10-minimal ;;
		*) printf 'Unknown distro: %s\n' "$distro" >&2; exit 2 ;;
	esac
	for runtime in jre jdk; do
		baseImage="eclipse-temurin:21-${runtime}-${suffix}"
		printf 'Checking %s on %s\n' "$baseImage" "$platform"
		docker run --rm -i --platform "$platform" --user 0 -e BIN_DIR=/tmp \
			-v "$repoDir/build/util/$distro/install-dependencies.sh:/tmp/install-dependencies.sh:ro" \
			"$baseImage" sh -s -- "$distro" <<'CONTAINER'
set -eu
sh /tmp/install-dependencies.sh >/tmp/install.log 2>&1 || { tail -60 /tmp/install.log; exit 1; }
for tool in bash curl jq zip unzip fc-list openssl useradd usermod groupadd groupmod getent; do
	command -v "$tool" >/dev/null || { printf 'Missing required tool: %s\n' "$tool" >&2; exit 1; }
done
printf '%s' '{"dependencies":true}' | jq -e '.dependencies == true' >/dev/null
printf 'dependency-check\n' >/tmp/archive.txt
zip -q -j /tmp/archive.zip /tmp/archive.txt
unzip -p /tmp/archive.zip archive.txt | grep -qx 'dependency-check'
test -n "$(fc-list)"
case "$1" in
	debian)
		test "$(/tmp/docker-java-home)" = "$JAVA_HOME"
		if dpkg-query -W -f='${db:Status-Abbrev} ${binary:Package}\n' | grep -E '^ii +(libc6-dev|libc-dev-bin|libc-devtools|linux-libc-dev|libreadline-dev|libncurses-dev|libcrypt-dev|apt-utils|bzip2|gnupg|wget)(:|$)'; then
			exit 1
		fi
		;;
	redhat)
		test "$(/tmp/docker-java-home)" = "$JAVA_HOME"
		for package in glibc-devel wget bzip2 which procps-ng gnupg2 util-linux; do
			if rpm -q "$package" >/dev/null 2>&1; then exit 1; fi
		done
		;;
	alpine)
		for package in glib libx11 libxrender libxext; do
			if apk info -e "$package" >/dev/null; then exit 1; fi
		done
		;;
esac
java -version
if command -v jshell >/dev/null; then
	fontOutput=$(jshell -J-Djava.awt.headless=true --feedback concise <<'JAVA'
import java.awt.*;
import java.awt.image.*;
import javax.imageio.*;
import java.io.*;
{
    var fonts = GraphicsEnvironment.getLocalGraphicsEnvironment().getAvailableFontFamilyNames();
    if (fonts.length == 0) throw new IllegalStateException("No fonts available");
    var image = new BufferedImage(240, 80, BufferedImage.TYPE_INT_RGB);
    var graphics = image.createGraphics();
    graphics.setFont(new Font("SansSerif", Font.PLAIN, 20));
    graphics.drawString("CommandBox fonts", 10, 40);
    graphics.dispose();
    var output = new ByteArrayOutputStream();
    if (!ImageIO.write(image, "png", output) || output.size() == 0) throw new IllegalStateException("Image rendering failed");
    System.out.println("Font/image smoke test passed");
}
/exit
JAVA
)
	printf '%s\n' "$fontOutput" | grep -q 'Font/image smoke test passed'
fi
printf 'Dependency checks passed\n'
CONTAINER
	done
done