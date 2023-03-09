#!/bin/bash
set -e

if [[ $CFPM_INSTALL ]]; then
    logMessage "INFO" "Coldfusion Package Manager Installation initiated to server directory: ${BOX_SERVER_APP_SERVERHOMEDIRECTORY}"

    if [[ ! -f $BOX_SERVER_APP_SERVERHOMEDIRECTORY/.engineInstall ]]; then
        logMessage "WARN" "The Adobe engine has not yet been installed on this server. The CFPM_INSTALL environment variable may only be used on warmed-up servers"
        exit 1
    fi

    $BOX_SERVER_APP_SERVERHOMEDIRECTORY/WEB-INF/cfusion/bin/cfpm.sh install $CFPM_INSTALL

fi

if [[ $CFPM_UNINSTALL ]]; then
    logMessage "INFO" "Coldfusion Package Manager Uninstallation specified for server directory: ${BOX_SERVER_APP_SERVERHOMEDIRECTORY}"

    if [[ ! -f $BOX_SERVER_APP_SERVERHOMEDIRECTORY/.engineInstall ]]; then
        logMessage "WARN" "The Adobe engine has not yet been installed on this server. The CFPM_UNINSTALL environment variable may only be used on warmed-up servers"
        exit 1
    fi

    IFS=","
    
    for package in $CFPM_UNINSTALL
    do
        $BOX_SERVER_APP_SERVERHOMEDIRECTORY/WEB_INF/cfusion/bin/cfpm.sh uninstall $package
    done

fi