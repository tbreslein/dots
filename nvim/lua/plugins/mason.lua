require("mason").setup()
require("mason-tool-installer").setup({
    ensure_installed = {
        "efm",

        "cmakelint",
        "clang-format",

        "golangci-lint",
        "gopls",

        "black",

        "eslint_d",
        "prettier",

        "jq",
        "hadolint",
        "yamllint",

        "bash-language-server",
        "shellcheck",
        "shellharden", -- can format

        "lua-language-server",
        "stylua",
        "luacheck",
    },
    integrations = { ["mason-null-ls"] = false }
})
