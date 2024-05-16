require("mason").setup()
require("mason-tool-installer").setup({
    ensure_installed = {
        "efm",

        "cmakelint",
        "gersemi", -- cmake formatter
        "clang-format",

        "gopls",
        "golangci-lint",
        "gofumpt",

        "black",
        "ruff",

        "tsserver",
        "eslint_d",
        "prettier",

        "dockerls",
        "jq",
        "hadolint",
        "yamllint",

        "bash-language-server",
        "shellcheck",
        "shellharden", -- can format

        "lua-language-server",
        "luacheck",
        "stylua",
    },
    integrations = { ["mason-null-ls"] = false },
})
