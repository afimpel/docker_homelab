#!/bin/bash

send_notify() {
    text=$1
    icons=$2
    timeout=${3:-8000}
    urgency=${4:-normal}
    if [ -x "$(command -v notify-send)" ]; then
        if [ -f "logs/startup.pid" ]; then
            startup=$(cat logs/startup.pid)
            startupDate=$(diffTime "$startup")
        else
            startupDate="Not running"
        fi
        /usr/bin/notify-send --category=homelab --urgency=$urgency "Compose use: ${COMPOSE_PROJECT_NAME^^}" "${text} | ${startupDate}" -a "${COMPOSE_PROJECT_NAME^^}" -i ${icons} -t $timeout 1>/dev/null 2>&1
    fi
}