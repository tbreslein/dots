local wezterm = require("wezterm")
local M = {}

function M.apply_to_config(config)
    config.colors = {
        foreground = "#d8dee9",
        background = "#242933",
        cursor_bg = "#d8dee9",
        cursor_fg = "#242933",
        cursor_border = "#d8dee9",
        selection_fg = "#d8dee9",
        selection_bg = "#2e3440",

        ansi = {
            "#191d24",
            "#bf616a",
            "#a3be8c",
            "#ebcb8b",
            "#81a1c1",
            "#b48ead",
            "#8fbcbb",
            "#d8dee9",
        },
        brights = {
            "#3b4252",
            "#d06f79",
            "#b1d196",
            "#f0d399",
            "#88c0d0",
            "#c895bf",
            "#93ccdc",
            "#e5e9f0",
        },
    }
end
return M
