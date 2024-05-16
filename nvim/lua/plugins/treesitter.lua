require("nvim-treesitter.configs").setup({
    highlight = { enable = true, additional_vim_regex_highlighting = true },
    indent = { enable = true },
    autotag = { enable = true },
})
require("treesitter-context").setup({ multiline_threshold = 2 })

vim.filetype.add({
    pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
