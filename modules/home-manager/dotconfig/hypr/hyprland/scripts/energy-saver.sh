#!/usr/bin/env sh
set -eu

HYPR_ENERGY_SAVER_MODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPR_ENERGY_SAVER_MODE" = 1 ] || [ "$HYPR_ENERGY_SAVER_MODE" = "true" ]; then
  hyprctl eval 'hl.config({animations={enabled=false},decoration={shadow={enabled=false},blur={enabled=false},active_opacity=1,inactive_opacity=1,rounding=0},general={border_size=1},misc={vrr=1}})'
  notify-send -u low -t 2000 "Energy Saver" "Animations, blur & shadow disabled"
  exit
fi

hyprctl reload
notify-send -u low -t 2000 "Energy Saver" "Full performance restored"
