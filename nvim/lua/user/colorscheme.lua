local M = {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
}

function M.config()
    require("nordic").setup({
        transparent_bg = true,
        telescope = { style = "classic" }
    })
    vim.cmd.colorscheme "nordic"
end

return M
