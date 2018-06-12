#!/bin/bash

# Cleanup CommandBox modules which would not be necessary in a Container environment
UI_MODULES=( "coldbox" "contentbox" "cachebox" "forgebox" "logbox" "games" "wirebox" )

for mod in "${UI_MODULES[@]}"
do
	rm -rf /root/.CommandBox/cfml/system/modules_app/${mod}-commands
done

# Remove any engine artifacts
rm -rf /root/.CommandBox/server/*
# Remove any temp files
rm -rf /root/.CommandBox/temp/*
# Remove any log files
rm -rf /root/.CommandBox/logs/*
# Clear downloaded artificacts
box artifacts clean --force