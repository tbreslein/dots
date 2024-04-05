local wezterm = require("wezterm")
local M = {}

function M.apply_to_config(config)
    config.color_scheme = "Gruvbox Material (Gogh)"
end
return M
