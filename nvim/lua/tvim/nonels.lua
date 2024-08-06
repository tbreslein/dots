add {
  source = "nvimtools/none-ls.nvim",
  depends = { "nvimtools/none-ls-extras.nvim" },
}

local null_ls = require "null-ls"
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup {
  sources = {
    null_ls.builtins.code_actions.statix,
    require("none-ls.code_actions.eslint").with {
      prefer_local = "node_modules/.bin",
    },

    require("none-ls.diagnostics.eslint").with {
      prefer_local = "node_modules/.bin",
    },
    null_ls.builtins.diagnostics.cppcheck,
    null_ls.builtins.diagnostics.golangci_lint,
    null_ls.builtins.diagnostics.hadolint,
    null_ls.builtins.diagnostics.statix,
    null_ls.builtins.diagnostics.zsh,

    null_ls.builtins.formatting.alejandra,
    null_ls.builtins.formatting.black.with {
      prefer_local = ".venv/bin",
    },
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.formatting.cmake_format,
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.prettier.with {
      prefer_local = "node_modules/.bin",
    },
    null_ls.builtins.formatting.stylua,
  },
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}
