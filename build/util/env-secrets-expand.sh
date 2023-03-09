#!/bin/bash

# credit: https://medium.com/@basi/docker-environment-variables-expanded-from-secrets-8fa70617b3bc

: ${ENV_SECRETS_DIR:=/run/secrets}

env_secret_debug()
{
    if [ ! -z "$ENV_SECRETS_DEBUG" ]; then
        logMessage "DEBUG" "$1"
    fi
}

# usage: env_secret_expand VAR
#    ie: env_secret_expand 'XYZ_DB_PASSWORD'
# (will check for "$XYZ_DB_PASSWORD" variable value for a placeholder that defines the
#  name of the docker secret to use instead of the original value. For example:
# XYZ_DB_PASSWORD=<<SECRET:my-db.secret>>
env_secret_expand() {
    local var="$1"
    eval local val=\$$var
    local secret_name=$(expr match "$val" "<<SECRET:\([^}]\+\)>>$")
    
    if [[ $secret_name ]]; then
        local secret="${ENV_SECRETS_DIR}/${secret_name}"
    elif [[ ${var:(-5)} = '_FILE' ]]; then
        local suffix=${var:(-5)}
        local secret=$val
    fi

    if [[ $secret ]]; then
        env_secret_debug "Secret file for $var: $secret"
        if [ -f "$secret" ]; then
            val=$(cat "${secret}")
            if [ $suffix ]; then
                echo "Expanding from _FILE suffix"
                var=$(echo $var | rev | cut -d '_' -f 2- | rev);
            fi
            export "$var"="$val"
            env_secret_debug "Expanded variable: $var=$val"
        else
            export "$var"=""
            env_secret_debug "Secret file does not exist! $secret"
        fi
    fi
}

env_secrets_expand() {
    for env_var in $(printenv | cut -f1 -d"=")
    do
        env_secret_expand $env_var
    done

    if [ ! -z "$ENV_SECRETS_DEBUG" ]; then
        logMessage "DEBUG" 'Expanded environment variables'
        printenv
    fi
}

env_secrets_expand
