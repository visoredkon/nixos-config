#!/usr/bin/env sh

if [ "$IS_ROFI_MODI" = "true" ]; then
  ACTION="$1"
  SELECTION="$2"

  if [ -n "$SELECTION" ]; then
    case "$ACTION" in
    c)
      printf "%s" "$SELECTION" | cliphist decode | wl-copy
      ;;
    d)
      printf "%s" "$SELECTION" | cliphist delete
      ;;
    esac
    exit 0
  fi

  tmp_dir="/tmp/cliphist"
  rm -rf "$tmp_dir"
  mkdir -p "$tmp_dir"

  read -r -d '' prog <<EOF
/^[0-9]+\s<meta http-equiv=/ { next }
match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
    system("echo " grp[1] "\\\\\t | cliphist decode >$tmp_dir/"grp[1]"."grp[3])
    print \$0"\0icon\x1f$tmp_dir/"grp[1]"."grp[3]
    next
}
1
EOF

  cliphist list | gawk "$prog"
  exit 0
fi

ACTION=${1:-c}

if [ "$ACTION" = "w" ]; then
  CONFIRM=$(printf "no\nyes" | rofi -dmenu -i -p "Wipe all clipboard")
  if [ "$CONFIRM" = "yes" ]; then
    cliphist wipe
  fi
else
  MODI_NAME=$ACTION
  if [ "$ACTION" = "d" ]; then
    MODI_NAME="Delete selected item"
  fi

  THEME_OVERRIDES="element-icon { size: 64px; } window { width: 50%; } listview { lines: 5; fixed-num-lines: false; }"

  IS_ROFI_MODI="true" rofi -modi "$MODI_NAME:$(realpath "$0") $ACTION" -show "$MODI_NAME" -show-icons -theme-str "$THEME_OVERRIDES"
fi
