local wezterm = require("wezterm")
local config = {}
config.color_scheme = "catppuccin-mocha"
-- config.color_scheme = "tokyonight"
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 15
config.force_reverse_video_cursor = true
config.enable_tab_bar = false
config.window_background_opacity = 0.9

return config
