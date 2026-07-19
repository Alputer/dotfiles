local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font_size = 15
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"

config.default_prog = { "/opt/homebrew/bin/fish", "-l" }

return config

