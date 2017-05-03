#!/bin/bash
set -e

apt-get install --assume-yes rsync zip unzip

# Run the full contentbox install to pre-seed everything
cd ${APP_DIR} && box install
ls -la

# Ensure the modules_app directory exists or ACF will blow up
mkdir -p ${APP_DIR}/modules_app

cd $BUILD_DIR
ls -la

