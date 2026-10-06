#!/bin/sh
set -e

apk update

apk upgrade

apk add --no-cache curl \
			jq \
			bash \
			zip \
			unzip \
			openssl \
			libgcc \
			libstdc++ \
			shadow \
			fontconfig \
			&& rm -f /var/cache/apk/*
