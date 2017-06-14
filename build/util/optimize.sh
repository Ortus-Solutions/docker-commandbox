#!/bin/bash

# Cleanup CommandBox modules which would not be necessary in a Container environment
UI_MODULES=( "coldbox" "contentbox" "logbox" "games" "wirebox" )

for mod in "${UI_MODULES[@]}"
do
	rm -rf /root/.CommandBox/cfml/system/modules_app/${mod}-commands
done

# Clear downloaded artificacts
box artifacts clean --force