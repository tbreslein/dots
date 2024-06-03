local M = {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = "williamboman/mason.nvim",
}

function M.config()
  require("mason").setup()
  require("mason-tool-installer").setup {
    ensure_installed = {
      "cmakelint",
      "clang-format",
      "cmake-language-server",

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

      "marksman",

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
