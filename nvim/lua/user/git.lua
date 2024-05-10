local M = {
    "tpope/vim-fugitive",
    dependencies = { "lewis6991/gitsigns.nvim", opts = {} },
}

function M.config()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "bash",
            "vim",
            "vimdoc",
            "lua",
            "markdown",
            "markdown_inline",
            "python",
            "c",
            "cpp",
            "rust",
            "go",
            "zig",
            "astro",
            "html",
            "json",
            "javascript",
            "typescript",
            "css",
            "scss",
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
end

return M
