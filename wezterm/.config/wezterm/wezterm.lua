local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font('Hack Nerd Font')
config.font_size = 15
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"

return config

