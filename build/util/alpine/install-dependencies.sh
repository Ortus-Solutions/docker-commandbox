#!/bin/sh
set -e

apk update && apk add curl \
                        jq \
                        bash \
                        openssl \
                        libgcc \
                        libstdc++ \
                        libx11 \
                        glib \
                        libxrender \
                        libxext \
                        libintl \
                        shadow \
                        fontconfig \
                        procps \
                        && rm -f /var/cache/apk/*