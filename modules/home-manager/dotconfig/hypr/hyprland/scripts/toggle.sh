#!/usr/bin/env sh
set -eu

PIDS=$(ps aux | grep -F "$*" | grep -v grep | grep -v "$(basename "$0")" | awk '{print $2}')

if [ -n "$PIDS" ]; then
  kill $PIDS 2>/dev/null || true
else
  exec "$@"
fi
