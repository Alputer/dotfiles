#!/usr/bin/env bash
# Liquid Glass — follows macOS light/dark appearance at load time.

if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
  # shellcheck source=/dev/null
  source "${CONFIG_DIR:-$HOME/.config/sketchybar}/themes/liquid_glass_dark.sh"
else
  # shellcheck source=/dev/null
  source "${CONFIG_DIR:-$HOME/.config/sketchybar}/themes/liquid_glass_light.sh"
fi
