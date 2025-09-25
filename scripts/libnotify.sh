#!/bin/bash

send_notify() {
    text=$1
    icons=$2
    if [ -x "$(command -v notify-send)" ]; then
        startup=$(cat logs/startup.pid)
        startupDate=$(diffTime "$startup")
        /usr/bin/notify-send "Compose use: ${COMPOSE_PROJECT_NAME^^}" "${text} | ${startupDate}" -a "HomeLab" -i ${icons} -t 8000 1>/dev/null 2>&1
    fi
}