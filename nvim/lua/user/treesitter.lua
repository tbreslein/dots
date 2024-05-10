local M = {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "windwp/nvim-ts-autotag",
        "nvim-treesitter/nvim-treesitter-context",
        { "indianboy42/tree-sitter-just", opts = {} },
    },
    build = ":TSUpdate",
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
            "hyprlang",
            "just",
        },
        highlight = { enable = true, additional_vim_regex_highlighting = true },
        indent = { enable = true },
        autotag = { enable = true },
    })
    require("treesitter-context").setup({ multiline_threshold = 2 })

    vim.filetype.add({
      pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
    })
end

return M
