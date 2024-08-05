local M = {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = "williamboman/mason.nvim",
}

function M.config()
  require("mason").setup()
  require("mason-tool-installer").setup {
    ensure_installed = {
      "clangd",
      "cmake-language-server",
      "cmakelint",
      "clang-format",

      "golangci-lint",
      "gofumpt",

      "typescript-language-server",
      "eslint_d",
      "prettier",

      "dockerfile-language-server",
      "jq",
      "hadolint",
      "yamllint",

      "bash-language-server",
      "shfmt",
      "shellcheck",

      -- "nil",
      -- "alejandra",
      -- "statix",

      "lua-language-server",
      "luacheck",
      "stylua",
    },
    integrations = { ["mason-null-ls"] = false },
  }
end

return M
