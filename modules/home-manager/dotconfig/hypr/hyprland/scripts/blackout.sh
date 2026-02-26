#!/usr/bin/env sh
set -eu

if [ "$(brightnessctl get)" -le 5 ]; then
  brightnessctl -r
else
  brightnessctl -s set 0
fi
