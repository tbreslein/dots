local wezterm = require("wezterm")
local M = {}

function M.apply_to_config(config)
    config.color_scheme = "catppuccin"
end
return M
