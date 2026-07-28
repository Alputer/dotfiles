#!/usr/bin/env bash

# Args: workspace id (B|S|C|T)
# Highlight the focused AeroSpace workspace.

source "$CONFIG_DIR/colors.sh"

FOCUSED_WORKSPACE="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    background.drawing=on \
    background.color="$RED" \
    icon.color="$TEXT" \
    label.color="$TEXT"
else
  sketchybar --set "$NAME" \
    background.drawing=off \
    icon.color="$SUBTEXT0" \
    label.color="$SUBTEXT0"
fi
