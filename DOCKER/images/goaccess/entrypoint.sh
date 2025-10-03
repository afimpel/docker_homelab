#!/bin/sh
set -eu
WS_ARG=""
if [ -n "${GOACCESS_WS_URL:-}" ]; then
  WS_ARG="--ws-url=${GOACCESS_WS_URL}"
elif [ -n "${WS_HOST:-}" ]; then
  WS_ARG="--ws-url=wss://${WS_HOST}/ws"
elif [ -n "${COMPOSE_PROJECT_NAME:-}" ]; then
  WS_ARG="--ws-url=wss://goaccess.${COMPOSE_PROJECT_NAME}.local/ws"
fi
GOACCESS_ADDR="${GOACCESS_ADDR:-0.0.0.0}"
FILE_ARGS="$(find /host_logs_var -type f -name '*access.log' -print0 2>/dev/null | xargs -0 -I{} printf ' -f %s' "{}" || true)"
if [ -z "$FILE_ARGS" ]; then
  echo "No logs found under /host_logs_var"
  exit 1
fi
rm -fv /var/report-html/report.html

echo "https://goaccess.${COMPOSE_PROJECT_NAME}.local/"
echo "### $FILE_ARGS ###"
echo "### goaccess --addr="${GOACCESS_ADDR}" $FILE_ARGS "$@" ${WS_ARG:+$WS_ARG}"

exec goaccess --addr="${GOACCESS_ADDR}" $FILE_ARGS "$@" ${WS_ARG:+$WS_ARG}