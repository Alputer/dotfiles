#!/usr/bin/env bash

# Args: workspace id (1|2|3|4|5)
# Highlight the focused AeroSpace workspace and show its app icons.

source "$CONFIG_DIR/colors.sh"

WORKSPACE="$1"
FOCUSED_WORKSPACE="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

apps=$(aerospace list-windows --workspace "$WORKSPACE" --format '%{app-name}' 2>/dev/null | sort -u)
icon_strip=""
if [ -n "$apps" ]; then
  while IFS= read -r app; do
    [ -z "$app" ] && continue
    icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
  done <<< "$apps"
else
  icon_strip=" —"
fi

if [ "$WORKSPACE" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    label="$icon_strip" \
    background.drawing=on \
    background.color="$ACTIVE_PILL" \
    background.border_color="$RIM" \
    icon.color="$TEXT" \
    label.color="$TEXT"
else
  sketchybar --set "$NAME" \
    label="$icon_strip" \
    background.drawing=off \
    icon.color="$SUBTEXT0" \
    label.color="$SUBTEXT0"
fi

