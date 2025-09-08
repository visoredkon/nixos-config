#!/usr/bin/env sh

if [ $(brightnessctl get) -le 5 ]; then
  brightnessctl -r
else
  brightnessctl -s set 0
fi
