-- TODO:
-- [ ] configure DAP

function map(mode, keys, action, opts)
  vim.keymap.set(
    mode,
    keys,
    action,
    vim.tbl_extend("keep", opts or {}, { noremap = true, silent = true })
  )
end

require "tvim.vimsettings"
require "tvim.keymaps"

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
add = MiniDeps.add
require("mini.extra").setup {}

require "tvim.ui"
require "tvim.navigation"
require "tvim.lsp"
require "tvim.nonels"
