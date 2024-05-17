require("lint").linters_by_ft = {
    c = { "cppcheck" },
    cpp = { "cppcheck" },
    cmake = { "cmakelint" },

    go = { "golangcilint" },
    python = { "ruff" },
    nix = { "statix" },
    lua = { "luacheck" },
    bash = { "shellcheck" },
    fish = { "fish" },
    zsh = { "zsh" },

    css = { "eslint" },
    html = { "eslint" },
    javascript = { "eslint" },
    javascriptreact = { "eslint" },
    typescript = { "eslint" },
    typescriptreact = { "eslint" },
    svelte = { "eslint" },
    yaml = { "yamllint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})
