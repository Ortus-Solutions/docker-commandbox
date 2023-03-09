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
                        && rm -f /var/cache/apk/*
                        