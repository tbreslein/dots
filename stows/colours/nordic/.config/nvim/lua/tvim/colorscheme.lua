local M = {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
}

function M.config()
    require("nordic").setup({
        transparent_bg = true,
        telescope = { style = "classic" },
    })
    require("nordic").load()
end

return M
