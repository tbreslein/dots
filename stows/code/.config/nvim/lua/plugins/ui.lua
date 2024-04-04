return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "windwp/nvim-ts-autotag",
            "nvim-treesitter/nvim-treesitter-context",
            { "indianboy42/tree-sitter-just", opts = {} },
        },
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "vim",
                    "vimdoc",
                    "lua",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "rust",
                    "go",
                    "zig",
                    "html",
                    "json",
                    "javascript",
                    "typescript",
                    "css",
                    "yaml",
                    "toml",
                    "nix",
                    "just",
                },
                highlight = { enable = true, additional_vim_regex_highlighting = true },
                indent = { enable = true },
                autotag = { enable = true },
            })
            require("treesitter-context").setup({ multiline_threshold = 2 })
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = { component_separators = "", section_separators = "" },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {},
                -- lualine_b = { "branch", "diff" },
                lualine_c = { { "filename", path = 3 } },
                lualine_x = { "diagnostics" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
        },
    },
    "tpope/vim-fugitive",
    { "lewis6991/gitsigns.nvim", opts = {} },
    { "numToStr/Comment.nvim", opts = {} },
    { "j-hui/fidget.nvim", opts = {} },
}
