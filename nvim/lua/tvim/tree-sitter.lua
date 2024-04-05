local M = {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "windwp/nvim-ts-autotag",
        "nvim-treesitter/nvim-treesitter-context",
        { "indianboy42/tree-sitter-just", opts = {} },
    },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
}

function M.config()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "bash",
            "zsh",
            "fish",
            "sh",
            "vim",
            "vimdoc",
            "markdown",
            "markdown_inline",
            "lua",
            "python",
            "c",
            "cpp",
            "rust",
            "go",
            "zig",
            "haskell",
            "ocaml",
            "html",
            "css",
            "javascript",
            "typescript",
            "json",
            "jq",
            "yaml",
            "toml",
            "nix",
            "just",
            "make",
        },
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true },
        autotag = { enable = true },
    })
    require("treesitter-context").setup({ multiline_threshold = 2 })
end

return M
