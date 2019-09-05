#!/bin/bash

set -ex

# Install the CommandBox-DotEnv module
box install commandbox-dotenv --production
$BUILD_DIR/util/optimize.sh
