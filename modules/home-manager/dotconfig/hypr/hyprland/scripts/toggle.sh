#!/usr/bin/env sh

ARGS="$@"

if ! (ps aux | rg "$ARGS" | rg -v rg | rg -v "hypr/hyprland" | awk '{print $2}' | xargs kill); then
  $ARGS
fi
