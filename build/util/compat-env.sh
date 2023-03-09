#!/bin/bash
set -e

## Deprecated environment variables which will continue to be handled until v4
if [ $SERVER_HOME_DIRECTORY ]; then
    logMessage "WARN" "The environment variable SERVER_HOME_DIRECTORY has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_APP_SERVERHOMEDIRECTORY instead."
    export BOX_SERVER_APP_SERVERHOMEDIRECTORY=$SERVER_HOME_DIRECTORY
fi

if [ $cfconfigfile ]; then
    logMessage "WARN" "The environment variable cfconfigfile has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_CFCONFIGFILE instead."
    export BOX_SERVER_CFCONFIGFILE=$cfconfigfile
fi

if [[ $CFCONFIG ]]; then
    logMessage "WARN" "The environment variable CFCONFIG has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_CFCONFIGFILE instead."
    export BOX_SERVER_CFCONFIGFILE=$CFCONFIG
fi

if [ $CFENGINE ]; then
    logMessage "WARN" "The environment variable CFENGINE has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_APP_CFENGINE instead."
    export BOX_SERVER_APP_CFENGINE=$CFENGINE
fi

if [ $SERVER_PROFILE ]; then
    logMessage "WARN" "The environment variable SERVER_PROFILE has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_PROFILE instead."
    export BOX_SERVER_PROFILE=$SERVER_PROFILE
fi

if [[ $HEADLESS ]] || [[ $headless ]]; then
    logMessage "WARN" "The environment variable HEADLESS has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_PROFILE instead."
    export BOX_SERVER_PROFILE=production
fi

if [ $URL_REWRITES ]; then
    logMessage "WARN" "The environment variable URL_REWRITES has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_WEB_REWRITES_ENABLE instead."
    export BOX_SERVER_WEB_REWRITES_ENABLE=$URL_REWRITES
fi

if [ $DEBUG ]; then
    logMessage "WARN" "The environment variable DEBUG has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_DEBUG instead."
    export BOX_SERVER_DEBUG=$DEBUG
fi