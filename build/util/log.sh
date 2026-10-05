#!/bin/bash
set -e
logFormat=${BOX_SERVER_RUNWAR_CONSOLE_APPENDERLAYOUT:=PatternLayout}

if [[ $box_server_runwar_console_appenderLayout ]]; then
    logFormat=${box_server_runwar_console_appenderLayout}
fi

if [[ $logFormat = 'JSONTemplateLayout' ]]; then
    export JAVA_TOOL_OPTIONS="-Dlogging.structured-format.console=ECS $JAVA_TOOL_OPTIONS"
else
    export JAVA_TOOL_OPTIONS="-Djava.util.logging.SimpleFormatter.format=\"[%4\$s] %1\$tFT%1\$tT.%1\$tL%1\$tz - %5\$s%n\" $JAVA_TOOL_OPTIONS"
fi

# Global logger function
logMessage () {
	local level=$1
	local message=$2
	local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

	if [[ $logFormat = 'JSONTemplateLayout' ]]; then
        printf '\n'
        echo $( jq --null-input \
                --arg lvl "$level" \
                --arg ts "$timestamp" \
                --arg msg "$message" \
                '{ "@timestamp" : $ts, "message" : $msg, "log" : { "level": $lvl } }' )
	else
        printf "%s\n" "[$level] $timestamp - $message"
	fi
}