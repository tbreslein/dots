vim.diagnostic.config {
  virtual_text = {
    prefix = "",
    suffix = "",
  },
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

add {
  source = "neovim/nvim-lspconfig",
  depends = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "onsails/lspkind.nvim",
    "jmbuhr/otter.nvim",
  },
}

add {
  source = "folke/lazydev.nvim",
  depends = { "Bilal2453/luvit-meta" },
}

require("lazydev").setup {
  library = { path = "luvit-meta/library", words = { "vim%.uv" } },
}
vim.g.lazydev_enabled = true

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
    ["<c-j>"] = cmp.mapping.select_next_item(select_opts),
    ["<c-k>"] = cmp.mapping.select_prev_item(select_opts),
    ["<c-l>"] = cmp.mapping.confirm { select = true },
    ["<c-n>"] = cmp.mapping(cmp.mapping.scroll_docs(-4)),
    ["<c-m>"] = cmp.mapping(cmp.mapping.scroll_docs(4)),
    ["<c-f>"] = cmp.mapping(function(fallback)
      if vim.snippet.active { direction = 1 } then
        return "<cmd>lua vim.snippet.jump(1)<cr>"
      else
        return "<c-f>"
      end
    end, { "i", "s" }),
    ["<c-b>"] = cmp.mapping(function(fallback)
      if vim.snippet.active { direction = -1 } then
        return "<cmd>lua vim.snippet.jump(-1)<cr>"
      else
        return "<c-b>"
      end
    end, { "i", "s" }),
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
      kind.menu = ""
      return kind
    end,
  },
  sources = {
    { name = "path" },
    { name = "nvim_lsp", keyword_length = 1 },
    { name = "nvim_lsp_signature_help" },
    { name = "lazydev", group_index = 0 },
    { name = "buffer", keyword_length = 3 },
    { name = "otter" },
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
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

local lsp_servers = {
  "bashls",
  "rust_analyzer",
  "dockerls",
  "gopls",
  "hyprls",
  "marksman",
  "tsserver",
  "ruff",
  "clangd",
  "cmake",
  "nil_ls",
  "zls",
}
for _, s in ipairs(lsp_servers) do
  lspconfig[s].setup { capabilities = lsp_capabilities }
end

vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

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
  cmd = { "lua-lsp" },
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

map("n", "gl", vim.diagnostic.open_float, "open float")
map("n", "]d", vim.diagnostic.goto_next, "next diag")
map("n", "[d", vim.diagnostic.goto_prev, "prev diag")
map("n", "<leader>fd", ":FzfLua diagnostics_workspace", "pick diags")
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(e)
    vim.bo[e.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    map("n", "<leader>sd", vim.diagnostic.setloclist, "setloclist to diags")

    map("n", "<leader>hi", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, "toggle inlay hints")

    map("n", "K", vim.lsp.buf.hover, "lsp hover")
    map("n", "gd", vim.lsp.buf.definition, "goto definition")
    map("n", "<leader>lh", vim.lsp.buf.declaration, "goto declaration")
    map("n", "<leader>lt", vim.lsp.buf.type_definition, "goto type def")
    map("n", "<leader>li", vim.lsp.buf.implementation, "goto implementation")
    map("n", "<leader>lr", ":FzfLua lsp_references<cr>", "pick references")
    map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, "code actions")
    map("n", "<leader>lf", vim.lsp.buf.format, "lsp format")
    map("n", "<leader>lc", vim.lsp.buf.rename, "lsp rename")
    map(
      { "i", "s" },
      "<c-space>",
      vim.lsp.buf.signature_help,
      "toggle sig help"
    )
  end,
})
