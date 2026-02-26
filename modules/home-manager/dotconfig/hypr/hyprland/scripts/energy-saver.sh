#!/usr/bin/env sh
set -eu

HYPR_ENERGY_SAVER_MODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPR_ENERGY_SAVER_MODE" = 1 ]; then
  hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword decoration:active_opacity 1;\
        keyword decoration:inactive_opacity 1;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0;\
        keyword misc:vfr 1;"
  notify-send "Energy Save: On"
  exit
fi

hyprctl reload
notify-send "Energy Save: Off"
