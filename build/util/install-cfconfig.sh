#!/bin/bash

set -e

# Install the CFConfig Module
box install commandbox-cfconfig --production
$BUILD_DIR/util/optimize.sh
