local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "onsails/lspkind.nvim",
    "mrcjkb/rustaceanvim",
    "jmbuhr/otter.nvim",
    "folke/trouble.nvim",
    "j-hui/fidget.nvim",
  },
}

function M.config()
  require("trouble").setup()
  require("fidget").setup()
  local lspconfig = require "lspconfig"
  local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
  local cmp = require "cmp"
  local select_opts = { behavior = cmp.SelectBehavior.Select }

  cmp.setup {
    snippet = {
      expand = function(args)
        vim.snippet.expand(args.body)
      end,
    },
    window = { documentation = cmp.config.window.bordered() },
    mapping = cmp.mapping.preset.insert {
      ["<c-p>"] = cmp.config.disable,
      ["<c-f>"] = cmp.config.disable,
      ["<c-b>"] = cmp.config.disable,
      ["<c-j>"] = cmp.mapping.select_next_item(select_opts),
      ["<c-k>"] = cmp.mapping.select_prev_item(select_opts),
      ["<c-l>"] = cmp.mapping.confirm { select = true },
      ["<c-n>"] = cmp.mapping(cmp.mapping.scroll_docs(-4)),
      ["<c-m>"] = cmp.mapping(cmp.mapping.scroll_docs(4)),
      -- ["<Del>"] = cmp.mapping(function(fallback)
      --     if luasnip.expand_or_jumpable() then
      --         luasnip.expand_or_jump()
      --     else
      --         fallback()
      --     end
      -- end, { "i", "s" }),
      -- ["<Tab>"] = cmp.mapping(function(fallback)
      --     if luasnip.jumpable(-1) then
      --         luasnip.jump(-1)
      --     else
      --         fallback()
      --     end
      -- end, { "i", "s" }),
    },
    enabled = function()
      return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
    end,
    formatting = {
      format = function(entry, vim_item)
        local kind = require("lspkind").cmp_format {
          mode = "symbol_text",
          maxwidth = 40,
        }(entry, vim_item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = " " .. (strings[1] or "") .. " "
        kind.menu = "    (" .. (strings[2] or "") .. ")"
        return kind
      end,
    },
    sources = {
      { name = "path" },
      { name = "nvim_lsp", keyword_length = 1 },
      { name = "buffer", keyword_length = 3 },
      -- { name = "luasnip" },
      { name = "nvim_lsp_signature_help" },
      { name = "otter" },
      { name = "neorg" },
    },
  }
  local cmp_cmdline_mappings = {
    ["<c-p>"] = cmp.config.disable,
    ["<c-j>"] = {
      c = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
    },
    ["<c-k>"] = {
      c = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
    },
  }
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(cmp_cmdline_mappings),
    sources = { { name = "buffer" } },
  })
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(cmp_cmdline_mappings),
    sources = cmp.config.sources(
      { { name = "path" } },
      { { name = "cmdline" } }
    ),
  })
  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

  lspconfig.bashls.setup { capabilities = lsp_capabilities }
  lspconfig.dockerls.setup { capabilities = lsp_capabilities }
  lspconfig.gopls.setup { capabilities = lsp_capabilities }
  lspconfig.marksman.setup { capabilities = lsp_capabilities }
  lspconfig.tsserver.setup { capabilities = lsp_capabilities }
  lspconfig.pyright.setup {
    capabilities = lsp_capabilities,
    on_new_config = function(config, root_dir)
      local env = vim.trim(
        vim.fn.system(
          'cd "'
            .. (root_dir or ".")
            .. '"; poetry env info --executable 2>/dev/null'
        )
      )
      if string.len(env) > 0 then
        config.settings.python.pythonPath = env
      end
    end,
  }
  lspconfig.lua_ls.setup {
    capabilities = lsp_capabilities,
    settings = {
      Lua = {
        runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          },
        },
      },
    },
  }
  lspconfig.clangd.setup { capabilities = lsp_capabilities }
  lspconfig.neocmake.setup { capabilities = lsp_capabilities }
  lspconfig.nil_ls.setup { capabilities = lsp_capabilities }
  lspconfig.zls.setup { capabilities = lsp_capabilities }

  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

  vim.diagnostic.config {
    signs = { active = true },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
    },
  }

  kmap("n", "gl", vim.diagnostic.open_float)
  kmap("n", "]d", function()
    vim.diagnostic.goto_next { float = true }
  end)
  kmap("n", "[d", function()
    vim.diagnostic.goto_prev { float = true }
  end)

  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
      kmap("n", "K", vim.lsp.buf.hover, { buffer = event.buf })
      kmap("n", "gd", vim.lsp.buf.definition, { buffer = event.buf })
      kmap("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf })
      kmap("n", "gi", vim.lsp.buf.implementation, { buffer = event.buf })
      kmap("n", "go", vim.lsp.buf.type_definition, { buffer = event.buf })
      kmap("n", "gr", ":Trouble lsp_references", { buffer = event.buf })
      kmap("n", "gs", vim.lsp.buf.signature_help, { buffer = event.buf })
      kmap("n", "<leader>R", vim.lsp.buf.rename, { buffer = event.buf })
      kmap("n", "<leader>A", vim.lsp.buf.code_action, { buffer = event.buf })
      kmap("n", "<F8>", function()
        vim.lsp.buf.format { async = false }
      end, { buffer = event.buf })
    end,
  })
end

return M
