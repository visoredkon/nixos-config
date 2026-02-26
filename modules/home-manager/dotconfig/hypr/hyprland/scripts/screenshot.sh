#!/usr/bin/env sh
set -eu

OUTPUT_DIR="$HOME/Pictures/Screenshots"
SILENT_DIR="$OUTPUT_DIR/.Silent"

mkdir -p "$OUTPUT_DIR"
mkdir -p "$SILENT_DIR"

TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
SILENT_FILENAME="$SILENT_DIR/$TIMESTAMP.png"
FOCUSED_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

case "${1:-}" in
silent)
  grim -o "$FOCUSED_MONITOR" - | tee "$SILENT_FILENAME" >/dev/null
  exit 0
  ;;
all)
  TMP_FILE=$(mktemp --suffix=.png)
  grim -o "$FOCUSED_MONITOR" "$TMP_FILE"
  ;;
rect)
  GEOMETRY=$(slurp) || exit 1
  TMP_FILE=$(mktemp --suffix=.png)
  grim -g "$GEOMETRY" "$TMP_FILE"
  ;;
window)
  GEOMETRY=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
  [ -z "$GEOMETRY" ] && exit 1
  TMP_FILE=$(mktemp --suffix=.png)
  grim -g "$GEOMETRY" "$TMP_FILE"
  ;;
*)
  exit 1
  ;;
esac

cleanup() {
  rm -f "$TMP_FILE"
}
trap cleanup EXIT

if [ -f "$TMP_FILE" ]; then
  wl-copy <"$TMP_FILE"
  swappy -f "$TMP_FILE"
  notify-send "Screenshot Taken" "Saved to clipboard and opened in editor." -i "$TMP_FILE"
else
  notify-send "Screenshot Failed" "Could not capture the image."
fi
