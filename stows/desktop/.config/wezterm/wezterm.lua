local wezterm = require("wezterm")
local colours = require("colours")
local config = {}
colours.apply_to_config(config)

local is_linux = wezterm.target_triple:find("linux") ~= nil
local is_darwin = wezterm.target_triple:find("darwin") ~= nil

local host = ""
if is_darwin then
    host = "darwin"
else
    host = wezterm.hostname()
end

if host == "darwin" then
    config.font_size = 15
elseif host == "moebius" then
    config.font_size = 18
elseif host == "audron" then
    config.font_size = 18
end

config.font = wezterm.font("0xProto Nerd Font")
config.force_reverse_video_cursor = true
config.enable_tab_bar = false
config.window_background_opacity = 0.9
config.term = "wezterm"

return config
