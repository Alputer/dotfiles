#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

SOURCE_ID="$(defaults read com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID 2>/dev/null)"
LAYOUT_NAME="$(defaults read com.apple.HIToolbox AppleSelectedInputSources 2>/dev/null \
  | awk -F'= ' '/KeyboardLayout Name/ {
      gsub(/^[[:space:]]*"?|"?[[:space:]]*;?$/, "", $2)
      print $2
      exit
    }')"

case "$SOURCE_ID" in
  *Turkish*|*turkish*)
    LABEL="TR"
    ;;
  *US*|*ABC*)
    LABEL="US"
    ;;
  *)
    case "$LAYOUT_NAME" in
      *Turkish*|*turkish*) LABEL="TR" ;;
      "U.S."|ABC|*U.S*) LABEL="US" ;;
      "") LABEL="?" ;;
      *) LABEL="$(printf '%.3s' "$LAYOUT_NAME" | tr '[:lower:]' '[:upper:]')" ;;
    esac
    ;;
esac

sketchybar --set "$NAME" icon="󰌌" icon.color="$YELLOW" label="$LABEL"
