local wezterm = require("wezterm")
local mycolours = require("colours")
local config = {}
mycolours.apply_to_config(config)
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 18
config.force_reverse_video_cursor = true
config.enable_tab_bar = false
config.window_background_opacity = 0.9
config.term = "wezterm"

return config
