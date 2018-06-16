#!/bin/bash

# Cleanup CommandBox modules which would not be necessary in a Container environment
SYSTEM_EXCLUDES=( "coldbox" "contentbox" "cachebox" "forgebox" "logbox" "games" "wirebox" )
MODULE_EXCLUDES=( "cfscriptme-command" "cb-module-template" )

for mod in "${SYSTEM_EXCLUDES[@]}"
do
	rm -rf /root/.CommandBox/cfml/system/modules_app/${mod}-commands
done

for mod in "${MODULE_EXCLUDES[@]}"
do
	rm -rf /root/.CommandBox/cfml/modules/${mod}
done

# Remove any engine artifacts
rm -rf /root/.CommandBox/server/*
# Remove any temp files
rm -rf /root/.CommandBox/temp/*
# Remove any log files
rm -rf /root/.CommandBox/logs/*
# Remove cachebox caches
rm -rf /root/.CommandBox/cfml/system/mdCache/*
# Remove the felix cache
rm -rf /root/.CommandBox/engine/cfml/cli/lucee-server/felix-cache/*
# Remove jGit jars as the commands have been removed
rm -rf /root/.CommandBox/lib/org.eclipse.jgit-*.jar
rm -rf /root/.CommandBox/lib/ortus-jgit.jar
# Clear downloaded artificacts
box artifacts clean --force