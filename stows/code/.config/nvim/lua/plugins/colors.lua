return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = true,
            integrations = {
                cmp = true,
                flash = true,
                gitsigns = true,
                harpoon = true,
                -- mason = true,
                treesitter = true,
                -- fidget = true,
            },
        })
        vim.cmd.colorscheme("catppuccin")
    end,
    -- "sainnhe/gruvbox-material",
    -- lazy = false,
    -- priority = 1000,
    -- config = function()
    --     vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
    --     vim.g.gruvbox_material_dim_inactive_windows = 1
    --     vim.g.gruvbox_material_transparent_background = 1
    --     vim.g.gruvbox_material_ui_contrast = "high"
    --     vim.cmd("colorscheme gruvbox-material")
    -- end,
}
