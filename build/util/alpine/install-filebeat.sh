#!/bin/sh
set -e

apk update && apk add filebeat \
                    && rm -f /var/cache/apk/*