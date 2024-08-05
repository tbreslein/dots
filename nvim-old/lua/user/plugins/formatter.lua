local M = {
  "mhartington/formatter.nvim",
}

function M.config()
  local util = require "formatter.util"
  require("formatter").setup {
    logging = true,
    log_level = vim.log.levels.WARN,
    filetype = {
      c = { require("formatter.filetypes.c").clangformat },
      cmake = { require("formatter.filetypes.cmake").cmakeformat },
      cpp = { require("formatter.filetypes.cpp").clangformat },
      rust = { require("formatter.filetypes.rust").rustfmt },
      zig = { require("formatter.filetypes.zig").zigfmt },

      go = { require("formatter.filetypes.go").gofumpt },
      haskell = { require("formatter.filetypes.haskell").stylish_haskell },
      python = {
        function()
          if vim.fn.executable "poetry" == 1 then
            return {
              exe = "poetry",
              args = {
                "-C",
                util.escape_path(util.get_current_buffer_file_path()),
                "run",
                "black",
                "-q",
                "--stdin-filename",
                util.escape_path(util.get_current_buffer_file_name()),
                "-",
              },
              stdin = true,
            }
          else
            return require("formatter.filetypes.python").black()
          end
        end,
      },
      -- python = { require("formatter.filetypes.python").black },
      -- python = { require("formatter.filetypes.python").ruff },
      nix = { require("formatter.filetypes.nix").alejandra },
      lua = { require("formatter.filetypes.lua").stylua },
      bash = { require("formatter.filetypes.sh").shfmt },
      sh = { require("formatter.filetypes.sh").shfmt },
      zsh = { require("formatter.filetypes.sh").shfmt },

      astro = {
        function()
          return {
            exe = "prettier",
            args = {
              "--stdin-filepath",
              util.escape_path(util.get_current_buffer_file_path()),
            },
            stdin = true,
            try_node_modules = true,
          }
        end,
      },
      css = { require("formatter.filetypes.css").prettier },
      html = { require("formatter.filetypes.html").prettier },
      javascript = { require("formatter.filetypes.javascript").prettier },
      javascriptreact = {
        require("formatter.filetypes.javascriptreact").prettier,
      },
      typescript = { require("formatter.filetypes.typescript").prettier },
      typescriptreact = {
        require("formatter.filetypes.typescriptreact").prettier,
      },
      json = { require("formatter.filetypes.json").prettier },
      jsonc = { require("formatter.filetypes.json").prettier },
      markdown = { require("formatter.filetypes.markdown").prettier },
      svelte = { require("formatter.filetypes.svelte").prettier },
      yaml = { require("formatter.filetypes.yaml").prettier },

      ["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
    },
  }

  local augroup = vim.api.nvim_create_augroup
  local autocmd = vim.api.nvim_create_autocmd
  augroup("__formatter__", { clear = true })
  autocmd("BufWritePost", {
    group = "__formatter__",
    command = ":FormatWrite",
  })
end

return M
