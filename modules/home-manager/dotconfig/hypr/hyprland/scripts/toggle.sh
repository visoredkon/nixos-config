#!/usr/bin/env sh
set -eu

PIDS=$(ps aux | grep -F "$*" | grep -v grep | grep -v toggle.sh | awk '{print $2}')

if [ -n "$PIDS" ]; then
  echo "$PIDS" | xargs kill 2>/dev/null || true
else
  exec "$@"
fi
