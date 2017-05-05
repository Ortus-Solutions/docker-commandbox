#!/bin/bash
set -e

# Run the full contentbox install to pre-seed everything
cd ${APP_DIR} && box install
ls -la ${APP_DIR}

# Ensure the modules_app directory exists or ACF will blow up
mkdir -p ${APP_DIR}/modules_app

# Ensure no server.json file exists
rm -f ${APP_DIR}/server.json

cd $BUILD_DIR
ls -la

