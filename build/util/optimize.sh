#!/bin/bash

echo "==> Optimizing CommandBox..."
# Clear downloaded artifacts
box artifacts clean --force
# Remove any temp files
rm -rf $COMMANDBOX_HOME/temp/*
# Remove any log files
rm -rf $COMMANDBOX_HOME/logs/*
# Remove cachebox caches
rm -rf $COMMANDBOX_HOME/cfml/system/mdCache/*
# Cleanup CommandBox files
rm -rfv $COMMANDBOX_HOME/cfml/system/config/server-icons/*.*
# Remove the felix cache
rm -rf $COMMANDBOX_HOME/engine/cfml/cli/lucee-server/felix-cache/*

# Clear out the identifier files so that each instance doesn't have the same id
rm -f ${COMMANDBOX_HOME}/engine/cfml/cli/lucee-server/context/id
rm -f ${COMMANDBOX_HOME}/engine/cfml/cli/cfml-web/id

# Cleanup
# More unecessary files
rm -rf /var/lib/{cache,log}/
# Remove Unecessary OS FIles
rm -rf /usr/share/icons /usr/share/doc /usr/share/man /usr/share/locale /tmp/*.*

echo "==> CommandBox cleanup complete"