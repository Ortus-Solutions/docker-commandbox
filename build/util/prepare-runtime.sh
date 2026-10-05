#!/bin/bash
set -e

if [[ $(id -u) = 0 ]]; then
	existingGroup=$(getent group 1000 | cut -d: -f1)
	case "$existingGroup" in
		ubuntu) groupmod -n "$WORKGROUP" ubuntu ;;
		"$WORKGROUP") ;;
		"") groupadd -g 1000 "$WORKGROUP" ;;
		*) printf 'GID 1000 is already assigned to %s\n' "$existingGroup" >&2; exit 1 ;;
	esac
	existingUser=$(getent passwd 1000 | cut -d: -f1)
	case "$existingUser" in
		ubuntu) usermod -l commandbox -d "$HOME" -g "$WORKGROUP" -s /bin/bash ubuntu ;;
		commandbox) usermod -g "$WORKGROUP" -d "$HOME" commandbox ;;
		"") useradd -u 1000 -g "$WORKGROUP" -d "$HOME" -s /bin/bash commandbox ;;
		*) printf 'UID 1000 is already assigned to %s\n' "$existingUser" >&2; exit 1 ;;
	esac
fi

runtimePaths=( "$HOME" "$APP_DIR" "$COMMANDBOX_HOME" "$BOXLANG_HOME" "${BOXLANG_INSTALL_HOME:-$BOXLANG_HOME}" "$LIB_DIR/serverHome" "$STARTUP_DIR" "$@" )
mkdir -p "${runtimePaths[@]}"
if [[ $(id -u) = 0 ]]; then
	chown -R commandbox:"$WORKGROUP" "${runtimePaths[@]}"
	chmod -R a+rX,go-w "$BIN_DIR" "$BUILD_DIR"
fi
chmod -R ug+rwX,o-w "${runtimePaths[@]}"
find "${runtimePaths[@]}" -type d -exec chmod g+s {} +