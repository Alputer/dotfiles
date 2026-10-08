#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

WIFI_IF="en0"
IP="$(ipconfig getifaddr "$WIFI_IF" 2>/dev/null)"
POWER="$(networksetup -getairportpower "$WIFI_IF" 2>/dev/null | awk '{print $NF}')"

if [ "$POWER" = "Off" ] || [ -z "$IP" ]; then
  ICON="󰖪"
  COLOR="$OVERLAY0"
else
  ICON="󰤨"
  COLOR="$TEAL"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label.drawing=off
