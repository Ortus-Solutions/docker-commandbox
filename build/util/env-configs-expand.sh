#!/bin/sh

# credit: https://medium.com/@basi/docker-environment-variables-expanded-from-secrets-8fa70617b3bc

env_config_debug()
{
    if [ ! -z "$ENV_CONFIGS_DEBUG" ]; then
        echo -e "\033[1m$@\033[0m"
    fi
}

# usage: env_config_expand VAR
#    ie: env_config_expand 'XYZ_DB_PASSWORD'
# (will check for "$XYZ_DB_PASSWORD" variable value for a placeholder that defines the
#  name of the docker config to use instead of the original value. For example:
# XYZ_DB_PASSWORD=<<CONFIG:my-db.config>>
env_config_expand() {
    var="$1"
    eval val=\$$var
    if config_name=$(expr match "$val" "<<CONFIG:\([^}]\+\)>>$"); then
        config="/${config_name}"
        env_config_debug "Config file for $var: $config"
        if [ -f "$config" ]; then
            val=$(cat "${config}")
            export "$var"="$val"
            env_config_debug "Expanded variable: $var=$val"
        else
            export "$var"=""
            env_config_debug "Config file does not exist! $config"
        fi
    fi
}

env_configs_expand() {
    for env_var in $(printenv | cut -f1 -d"=")
    do
        env_config_expand $env_var
    done

    if [ ! -z "$ENV_CONFIGS_DEBUG" ]; then
        echo -e "\n\033[1mExpanded environment variables\033[0m"
        printenv
    fi
}

env_configs_expand
