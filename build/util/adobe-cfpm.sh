#!/bin/bash

set -ex

if [[ $CFPM_INSTALL ]]; then

    if [[ ! -f $SERVER_HOME_DIRECTORY/.engineInstall ]]; then
        echo "The Adobe engine has not yet been installed on this server. The CFPM_INSTALL environment variable may only be used on warmed-up servers"
        exit 1
    fi

    IFS=","
    
    for package in $CFPM_INSTALL
    do
        $SERVER_HOME_DIRECTORY/WEB_INF/cfusion/bin/cfpm.sh install $package
    done

fi

if [[ $CFPM_UNINSTALL ]]; then

    if [[ ! -f $SERVER_HOME_DIRECTORY/.engineInstall ]]; then
        echo "The Adobe engine has not yet been installed on this server. The CFPM_UNINSTALL environment variable may only be used on warmed-up servers"
        exit 1
    fi

    IFS=","
    
    for package in $CFPM_UNINSTALL
    do
        $SERVER_HOME_DIRECTORY/WEB_INF/cfusion/bin/cfpm.sh uninstall $package
    done

fi