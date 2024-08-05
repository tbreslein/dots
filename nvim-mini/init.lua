-- TODO:
-- [ ] configure mini plugins
-- [ ] configure none-ls
-- [ ] configure LSP
-- [ ] configure DAP

-- VIM SETTINGS
vim.loader.enable()
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "80"
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 4
vim.opt.isfname:append "@-@"
vim.opt.updatetime = 50
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.foldenable = false
vim.opt.conceallevel = 0
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv "HOME" .. "/.local/share/vim/undodir"
vim.opt.undofile = true
vim.opt.linebreak = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "a"
vim.opt.fileencoding = "utf-8"
vim.opt.clipboard:append { "unnamed", "unnamedplus" }
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.fillchars = { eob = " " }
vim.opt.inccommand = "split"
vim.opt.autoread = true
vim.g.netrw_banner = 0
vim.g.netrw_mouse = 2
if vim.loop.os_uname().sysname == "Darwin" then
  vim.fn.setenv("CC", "gcc-14")
  vim.fn.setenv("CXX", "g++-14")
end
vim.filetype.add {
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
}

--- load shada after ui-enter
local shada = vim.o.shada
vim.o.shada = ""
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.o.shada = shada
    pcall(vim.cmd.rshada, { bang = true })
  end,
})

-- AUTOCMDS
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = "*",
})
vim.api.nvim_create_autocmd("FocusGained", { command = "checktime" })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "fugitive", "git", "help", "lspinfo", "man", "query", "vim" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set(
      "n",
      "q",
      "<cmd>close<cr>",
      { buffer = event.buf, silent = true }
    )
  end,
})
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.rs" },
  callback = function()
    vim.lsp.buf.format { async = false }
  end,
})

-- PLUGINS
-- local packages = {
--   "nvim-treesitter/nvim-treesitter-context",
--   "nvim-treesitter/nvim-treesitter-textobjects",
--   { "ThePrimeagen/harpoon", branch = "harpoon2" },
--   "ggandor/leap.nvim",
--   "lewis6991/gitsigns.nvim",
--
--   "nvimtools/none-ls.nvim",
--   -- "neovim/nvim-lspconfig",
--   -- "hrsh7th/nvim-cmp",
--   -- "hrsh7th/cmp-nvim-lsp",
--   -- "hrsh7th/cmp-path",
--   -- "hrsh7th/cmp-buffer",
--   -- "hrsh7th/cmp-cmdline",
--   -- "onsails/lspkind.nvim",
--   -- "jmbuhr/otter.nvim",
-- }

local path_package = vim.fn.stdpath "data" .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd 'echo "Installing `mini.nvim`" | redraw'
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd "packadd mini.nvim | helptags ALL"
  vim.cmd 'echo "Installed `mini.nvim`" | redraw'
end

-- Set up 'mini.deps' (customize to your liking)
require("mini.deps").setup { path = { package = path_package } }
local add = MiniDeps.add

-- COLORS / UI / TREESITTER
add "vague2k/vague.nvim"
require("vague").setup { transparent = false }

add "lewis6991/gitsigns.nvim"
require("gitsigns").setup {}

add {
  source = "nvim-treesitter/nvim-treesitter",
  hooks = {
    post_checkout = function()
      vim.cmd ":TSUpdate"
    end,
  },
}
require("nvim-treesitter.configs").setup {
  ensure_installed = "all",
  -- ensure_installed = {
  --   "lua",
  --   "git_config",
  --   "git_rebase",
  --   "gitattributes",
  --   "gitcommit",
  --   "gitignore",
  --   "vim",
  --   "vimdoc",
  --   "query",
  --   "ssh_config",
  --   "tmux",
  --   "hyprlang",
  -- },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = { "json" },
  },
  indent = { enable = true },
  autotag = { enable = true },
}
add "nvim-treesitter/nvim-treesitter-context"
add "nvim-treesitter/nvim-treesitter-textobjects"
require("treesitter-context").setup { multiline_threshold = 2 }
require("nvim-treesitter.configs").setup {
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}

-- NAVIGATION
add { source = "ThePrimeagen/harpoon", checkout = "harpoon2" }
local harpoon = require "harpoon"
harpoon.setup { settings = { save_on_toggle = true } }

-- LSP
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
  signs = {
    text = {
      [vim.diagnostic.severity.HINT] = "󱐮",
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.INFO] = "◉",
      [vim.diagnostic.severity.WARN] = "",
    },
  },
}
-- local lspconfig = require "lspconfig"
-- local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
-- local cmp = require "cmp"
-- local select_opts = { behavior = cmp.SelectBehavior.Select }
--
-- cmp.setup {
--   snippet = {
--     expand = function(args)
--       vim.snippet.expand(args.body)
--     end,
--   },
--   window = { documentation = cmp.config.window.bordered() },
--   mapping = cmp.mapping.preset.insert {
--     ["<c-p>"] = cmp.config.disable,
--     ["<c-f>"] = cmp.config.disable,
--     ["<c-b>"] = cmp.config.disable,
--     ["<c-j>"] = cmp.mapping.select_next_item(select_opts),
--     ["<c-k>"] = cmp.mapping.select_prev_item(select_opts),
--     ["<c-l>"] = cmp.mapping.confirm { select = true },
--     ["<c-n>"] = cmp.mapping(cmp.mapping.scroll_docs(-4)),
--     ["<c-m>"] = cmp.mapping(cmp.mapping.scroll_docs(4)),
--     -- ["<Del>"] = cmp.mapping(function(fallback)
--     --     if luasnip.expand_or_jumpable() then
--     --         luasnip.expand_or_jump()
--     --     else
--     --         fallback()
--     --     end
--     -- end, { "i", "s" }),
--     -- ["<Tab>"] = cmp.mapping(function(fallback)
--     --     if luasnip.jumpable(-1) then
--     --         luasnip.jump(-1)
--     --     else
--     --         fallback()
--     --     end
--     -- end, { "i", "s" }),
--   },
--   enabled = function()
--     return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
--   end,
--   formatting = {
--     format = function(entry, vim_item)
--       local kind = require("lspkind").cmp_format {
--         mode = "symbol_text",
--         maxwidth = 40,
--       }(entry, vim_item)
--       local strings = vim.split(kind.kind, "%s", { trimempty = true })
--       kind.kind = " " .. (strings[1] or "") .. " "
--       -- kind.menu = "    (" .. (strings[2] or "") .. ")"
--       kind.menu = ""
--       return kind
--     end,
--   },
--   sources = {
--     { name = "path" },
--     { name = "nvim_lsp", keyword_length = 1 },
--     { name = "buffer", keyword_length = 3 },
--     -- { name = "luasnip" },
--     { name = "nvim_lsp_signature_help" },
--     { name = "otter" },
--     { name = "neorg" },
--   },
-- }
-- local cmp_cmdline_mappings = {
--   ["<c-p>"] = cmp.config.disable,
--   ["<c-j>"] = {
--     c = function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       else
--         fallback()
--       end
--     end,
--   },
--   ["<c-k>"] = {
--     c = function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       else
--         fallback()
--       end
--     end,
--   },
-- }
-- cmp.setup.cmdline({ "/", "?" }, {
--   mapping = cmp.mapping.preset.cmdline(cmp_cmdline_mappings),
--   sources = { { name = "buffer" } },
-- })
-- cmp.setup.cmdline(":", {
--   mapping = cmp.mapping.preset.cmdline(cmp_cmdline_mappings),
--   sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
-- })
-- vim.lsp.handlers["textDocument/hover"] =
--   vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
--
-- lspconfig.bashls.setup { capabilities = lsp_capabilities }
-- lspconfig.rust_analyzer.setup { capabilities = lsp_capabilities }
-- lspconfig.dockerls.setup { capabilities = lsp_capabilities }
-- lspconfig.gopls.setup { capabilities = lsp_capabilities }
-- lspconfig.hyprls.setup { capabilities = lsp_capabilities }
-- lspconfig.marksman.setup { capabilities = lsp_capabilities }
-- lspconfig.tsserver.setup { capabilities = lsp_capabilities }
-- lspconfig.ruff.setup { capabilities = lsp_capabilities }
-- lspconfig.pyright.setup {
--   capabilities = lsp_capabilities,
--   on_new_config = function(config, root_dir)
--     local env = vim.trim(
--       vim.fn.system(
--         'cd "'
--           .. (root_dir or ".")
--           .. '"; poetry env info --executable 2>/dev/null'
--       )
--     )
--     if string.len(env) > 0 then
--       config.settings.python.pythonPath = env
--     end
--   end,
-- }
-- lspconfig.lua_ls.setup {
--   capabilities = lsp_capabilities,
--   settings = {
--     Lua = {
--       runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
--       diagnostics = { globals = { "vim" } },
--       workspace = {
--         library = {
--           [vim.fn.expand "$VIMRUNTIME/lua"] = true,
--           [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
--         },
--       },
--     },
--   },
-- }
-- lspconfig.clangd.setup { capabilities = lsp_capabilities }
-- lspconfig.cmake.setup { capabilities = lsp_capabilities }
-- lspconfig.nil_ls.setup { capabilities = lsp_capabilities }
-- lspconfig.zls.setup { capabilities = lsp_capabilities }
--
-- vim.lsp.handlers["textDocument/hover"] =
--   vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
--
-- kmap("n", "gl", vim.diagnostic.open_float)
-- kmap("n", "]d", function()
--   vim.diagnostic.goto_next { float = true }
-- end)
-- kmap("n", "[d", function()
--   vim.diagnostic.goto_prev { float = true }
-- end)
--
-- vim.api.nvim_create_autocmd("LspAttach", {
--   desc = "LSP actions",
--   callback = function(e)
--     kmap("n", "K", vim.lsp.buf.hover, { buffer = e.buf })
--     kmap("n", "gd", vim.lsp.buf.definition, { buffer = e.buf })
--     kmap("n", "gD", vim.lsp.buf.declaration, { buffer = e.buf })
--     kmap("n", "gi", vim.lsp.buf.implementation, { buffer = e.buf })
--     kmap("n", "go", vim.lsp.buf.type_definition, { buffer = e.buf })
--     kmap("n", "gr", ":Trouble lsp_references toggle<cr>", { buffer = e.buf })
--     kmap("n", "gs", vim.lsp.buf.signature_help, { buffer = e.buf })
--     kmap("n", "<leader>R", vim.lsp.buf.rename, { buffer = e.buf })
--     kmap("n", "<leader>A", vim.lsp.buf.code_action, { buffer = e.buf })
--     kmap(
--       "n",
--       "<leader>td",
--       ":Trouble diagnostics toggle<cr>",
--       { buffer = e.buf }
--     )
--     kmap(
--       "n",
--       "<leader>te",
--       ":Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>",
--       { buffer = e.buf }
--     )
--     kmap("n", "<F8>", function()
--       vim.lsp.buf.format { async = false }
--     end, { buffer = e.buf })
--   end,
-- })

-- KEYMAPS
local function map(mode, keys, action, desc, opts)
  vim.keymap.set(
    mode,
    keys,
    action,
    vim.tbl_extend(
      "keep",
      opts or {},
      { noremap = true, silent = true, desc = desc or "" }
    )
  )
end

map("n", "<m-r>", function()
  harpoon:list():select(1)
end)
map("n", "<m-e>", function()
  harpoon:list():select(2)
end)
map("n", "<m-w>", function()
  harpoon:list():select(3)
end)
map("n", "<m-q>", function()
  harpoon:list():select(4)
end)
map("n", "<m-t>", function()
  harpoon:list():select(5)
end)
map("n", "<leader>a", function()
  harpoon:list():add()
end)
map("n", "<leader>e", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

-- map("n", "<leader>ff",

map("n", "s", "<Plug>(leap)")
map("n", "Q", "<nop>")
map("n", "<esc>", ":noh<cr>")
map("t", "jk", "<c-\\><c-n>")

map("v", "P", [["_dP]])
map({ "n", "x", "v" }, "x", [["_x]])
map({ "n", "x", "v" }, "<leader>y", [["+y]])
map({ "n", "x", "v" }, "<leader>p", [["+p]])
map("n", "Y", "yg$")
map("n", "J", "mzJ`z")

map("v", "<leader>r", [["hy:%s/<c-r>h//g<left><left>]])

map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "*", "*zz")
map("n", "#", "#zz")
map("n", "g*", "g*zz")
map("n", "g#", "g#zz")
map("n", "<c-d>", "<c-d>zz")
map("n", "<c-u>", "<c-u>zz")

map("v", "<", "<gv")
map("v", ">", ">gv")
map("v", "J", ":m '>+1<cr>gv=gv")
map("v", "K", ":m '<-2<cr>gv=gv")
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

map("n", "<c-h>", "<c-w>h")
map("n", "<c-j>", "<c-w>j")
map("n", "<c-k>", "<c-w>k")
map("n", "<c-l>", "<c-w>l")

map("n", "]c", ":cnext<cr>zz")
map("n", "[c", ":cprev<cr>zz")
map("n", "<leader>C", function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
      break
    end
  end
  if qf_exists == true then
    return vim.cmd "cclose"
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    return vim.cmd "copen"
  end
end)
