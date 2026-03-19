#!/usr/bin/env bash

set -euo pipefail

readonly TMP_DIR="/tmp/cliphist"
readonly ROFI_THEME="element-icon { size: 64px; } window { width: 50%; } listview { lines: 5; fixed-num-lines: false; }"

die() {
  echo "Error: $*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Missing dependency: $1"
}

get_cliphist_list() {
  rm -rf "$TMP_DIR"
  mkdir -p "$TMP_DIR"

  local prog
  read -r -d '' prog <<'EOF' || true
/^[0-9]+\s<meta http-equiv=/ { next }
match($0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
    cmd = sprintf("printf \"%%s\\t\" %s | cliphist decode > %s/%s.%s", grp[1], tmp_dir, grp[1], grp[3])
    system(cmd)
    printf "%s\0icon\x1f%s/%s.%s\n", $0, tmp_dir, grp[1], grp[3]
    next
}
1
EOF

  cliphist list | gawk -v tmp_dir="$TMP_DIR" "$prog"
}

handle_rofi_modi() {
  local action="$1"
  local selection="${2:-}"

  if [[ -n $selection ]]; then
    if [[ $action == "c" ]]; then
      printf "%s" "$selection" | cliphist decode | wl-copy
    fi
    exit 0
  fi

  get_cliphist_list
  exit 0
}

handle_wipe() {
  local confirm
  confirm=$(printf "no\nyes\n" | rofi -dmenu -i -p "Wipe all clipboard")

  if [[ $confirm == "yes" ]]; then
    cliphist wipe
  fi
}

handle_delete_multi() {
  get_cliphist_list | rofi -dmenu -multi-select -i -p "Delete selected items" -show-icons -theme-str "$ROFI_THEME" | while IFS= read -r line; do
    if [[ -n $line ]]; then
      printf "%s\n" "$line" | cliphist delete
    fi
  done
}

launch_modi() {
  local action="$1"
  local script_path
  script_path=$(realpath "$0")

  IS_ROFI_MODI="true" rofi -modi "${action}:${script_path} ${action}" -show "$action" -show-icons -theme-str "$ROFI_THEME"
}

main() {
  require_cmd cliphist
  require_cmd rofi
  require_cmd gawk
  require_cmd wl-copy

  local is_modi="${IS_ROFI_MODI:-false}"
  local action="${1:-c}"
  local selection="${2:-}"

  if [[ $is_modi == "true" ]]; then
    handle_rofi_modi "$action" "$selection"
  fi

  if [[ $action == "w" ]]; then
    handle_wipe
  elif [[ $action == "d" ]]; then
    handle_delete_multi
  else
    launch_modi "$action"
  fi
}

main "$@"
