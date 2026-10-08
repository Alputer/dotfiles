#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "brightness_change" ]; then
  BRIGHTNESS="$INFO"

  case "$BRIGHTNESS" in
    [7-9][0-9]|100) ICON="󰃠" ;;
    [4-6][0-9])     ICON="󰃝" ;;
    [1-3][0-9])     ICON="󰃞" ;;
    *)              ICON="󰃜" ;;
  esac

  sketchybar --set "$NAME" icon="$ICON" label="${BRIGHTNESS}%"
fi
