#!/bin/bash
# Remove any temp files
rm -rf $HOME/.CommandBox/temp/*
# Remove any log files
rm -rf $HOME/.CommandBox/logs/*
# Remove cachebox caches
rm -rf $HOME/.CommandBox/cfml/system/mdCache/*
# Remove the felix cache
rm -rf $HOME/.CommandBox/engine/cfml/cli/lucee-server/felix-cache/*
# Clear downloaded artificacts
box artifacts clean --force