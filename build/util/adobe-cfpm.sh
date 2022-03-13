#!/bin/bash
set -e

if [[ -v $CFPM_INSTALL ]]; then

    if [[ ! -f $BOX_SERVER_APP_SERVERHOMEDIRECTORY/.engineInstall ]]; then
        echo "The Adobe engine has not yet been installed on this server. The CFPM_INSTALL environment variable may only be used on warmed-up servers"
        exit 1
    fi

    $BOX_SERVER_APP_SERVERHOMEDIRECTORY/WEB-INF/cfusion/bin/cfpm.sh install $CFPM_INSTALL

fi

if [[ -v $CFPM_UNINSTALL ]]; then

    if [[ ! -f $BOX_SERVER_APP_SERVERHOMEDIRECTORY/.engineInstall ]]; then
        echo "The Adobe engine has not yet been installed on this server. The CFPM_UNINSTALL environment variable may only be used on warmed-up servers"
        exit 1
    fi

    IFS=","
    
    for package in $CFPM_UNINSTALL
    do
        $BOX_SERVER_APP_SERVERHOMEDIRECTORY/WEB_INF/cfusion/bin/cfpm.sh uninstall $package
    done

fi