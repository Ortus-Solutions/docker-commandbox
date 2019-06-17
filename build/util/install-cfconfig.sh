#!/bin/bash

set -ex

# Install the CFConfig Module
box install commandbox-cfconfig --production
$BUILD_DIR/util/optimize.sh
