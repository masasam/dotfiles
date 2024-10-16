-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
config.automatically_reload_config = true
config.font_size = 21
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Solarized (dark) (terminal.sexy)'

-- and finally, return the configuration to wezterm
return config