#!/bin/bash
set -e

## Deprecated environment variables which will continue to be handled until v4
if [ $SERVER_HOME_DIRECTORY ]; then
    echo "WARN: Then environment variable SERVER_HOME_DIRECTORY has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_APP_SERVERHOMEDIRECTORY instead."
    export BOX_SERVER_APP_SERVERHOMEDIRECTORY=$SERVER_HOME_DIRECTORY
fi

if [ $cfconfigfile ]; then
    echo "WARN: Then environment variable cfconfigfile has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_CFCONFIGFILE instead."
    export BOX_SERVER_CFCONFIGFILE=$cfconfigfile
fi

if [[ $CFCONFIG ]]; then
    echo "WARN: Then environment variable CFCONFIG has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_CFCONFIGFILE instead."
    export BOX_SERVER_CFCONFIGFILE=$CFCONFIG
fi

if [ $CFENGINE ]; then
    echo "WARN: Then environment variable CFENGINE has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_APP_CFENGINE instead."
    export BOX_SERVER_APP_CFENGINE=$CFENGINE
fi

if [ $SERVER_PROFILE ]; then
    echo "WARN: Then environment variable SERVER_PROFILE has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_PROFILE instead."
    export BOX_SERVER_PROFILE=$SERVER_PROFILE
fi

if [[ $HEADLESS ]] || [[ $headless ]]; then
    echo "WARN: Then environment variable HEADLESS has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_PROFILE instead."
    export BOX_SERVER_PROFILE=production
fi

if [ $URL_REWRITES ]; then
    echo "WARN: Then environment variable URL_REWRITES has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_WEB_REWRITES_ENABLE instead."
    export BOX_SERVER_WEB_REWRITES_ENABLE=$URL_REWRITES
fi

if [ $DEBUG ]; then
    echo "WARN: Then environment variable DEBUG has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_DEBUG instead."
    export BOX_SERVER_DEBUG=$DEBUG
fi