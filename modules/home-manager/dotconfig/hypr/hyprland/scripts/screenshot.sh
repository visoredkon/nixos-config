#!/usr/bin/env sh

OUTPUT_DIR="$HOME/Pictures/Screenshots"
SILENT_DIR="$OUTPUT_DIR/.Silent"

mkdir -p "$OUTPUT_DIR"
mkdir -p "$SILENT_DIR"

FILENAME="$OUTPUT_DIR/$(date +'%Y-%m-%d_%H-%M-%S').png"
SILENT_FILENAME="$SILENT_DIR/$(date +'%Y-%m-%d_%H-%M-%S').png"

TMP_FILE=$(mktemp --suffix=.png)

cleanup() {
  rm -f "$TMP_FILE"
}
trap cleanup EXIT

case "$1" in
all)
  grim "$TMP_FILE"
  ;;
silent)
  grim - | tee "$SILENT_FILENAME" >/dev/null
  ;;
rect)
  GEOMETRY=$(slurp)
  [ -z "$GEOMETRY" ] && exit 1
  grim -g "$GEOMETRY" "$TMP_FILE"
  ;;
window)
  GEOMETRY=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
  [ -z "$GEOMETRY" ] && exit 1
  grim -g "$GEOMETRY" "$TMP_FILE"
  ;;
esac

if [ "$1" != "silent" ]; then
  if [ -f "$TMP_FILE" ]; then
    cp "$TMP_FILE" "$FILENAME"

    wl-copy <"$TMP_FILE"
    swappy -f "$TMP_FILE"

    notify-send "Screenshot Taken" "Saved to clipboard." -i "$TMP_FILE"
  else
    notify-send "Screenshot Failed" "Could not capture the image."
  fi
fi
