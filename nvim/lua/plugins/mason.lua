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

        "typescript-language-server",
        "eslint_d",
        "prettier",

        "dockerfile-language-server",
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
