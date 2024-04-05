local M = {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
}

function M.config()
    require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        integrations = {
            cmp = true,
            flash = true,
            gitsigns = true,
            harpoon = true,
            mason = true,
            treesitter = true,
            fidget = true,
        },
    })
    vim.cmd.colorscheme("catppuccin")
end

return M
