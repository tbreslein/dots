require("nvim-treesitter.parsers").get_parser_configs().just = {
    install_info = {
        url = "https://github.com/IndianBoy42/tree-sitter-just",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "main",
    },
    maintainers = { "@IndianBoy42" },
}
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "c",
        "cpp",
        "cmake",
        "meson",
        "ninja",
        "fortran",
        "rust",
        "zig",

        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",

        "ssh_config",
        "tmux",
        "bash",
        "fish",
        "vim",
        "vimdoc",
        "query",
        "just",
        "nix",
        "nickel",
        "lua",
        "go",
        "python",
        "haskell",
        "dockerfile",

        "norg",
        "markdown",
        "markdown_inline",

        "astro",
        "angular",
        "html",
        "json",
        "css",
        "scss",
        "javascript",
        "typescript",
        "svelte",
        "yaml",
        "toml",
        "hyprlang",
    },
    highlight = { enable = true, additional_vim_regex_highlighting = false, disable = { "json" } },
    indent = { enable = true },
    autotag = { enable = true },
})
require("treesitter-context").setup({ multiline_threshold = 2 })

vim.filetype.add({
    pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
