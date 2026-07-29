#!/usr/bin/env bash
# Map a single macOS app name to a sketchybar-app-font glyph.

source "$(dirname "$0")/icon_map.sh"
__icon_map "$1"
echo "$icon_result"
