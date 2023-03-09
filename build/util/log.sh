#!/bin/bash
set -e
logFormat=${BOX_SERVER_RUNWAR_CONSOLE_APPENDERLAYOUT:=PatternLayout}

if [[ $box_server_runwar_console_appenderLayout ]]; then
    logFormat=${box_server_runwar_console_appenderLayout}
fi

# Global logger function
logMessage () {
	local level=$1
	local message=$2
	local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

	if [[ $logFormat = 'JSONTemplateLayout' ]]; then
        echo $( jq --null-input \
                --arg lvl "$level" \
                --arg ts "$timestamp" \
                --arg msg "$message" \
                '{ "@timestamp" : $ts, "message" : $msg, "log" : { "level": $lvl } }' )
	else
        printf "%s\n" "[$level] $timestamp - $message"
	fi
}