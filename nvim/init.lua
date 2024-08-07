vim.loader.enable()
function map(mode, keys, action, desc, opts)
  vim.keymap.set(
    mode,
    keys,
    action,
    vim.tbl_extend(
      "keep",
      opts or {},
      { noremap = true, silent = true, desc = desc }
    )
  )
end

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
require("mini.deps").setup { path = { package = path_package } }
add = MiniDeps.add

MiniDeps.now(function()
  require "tvim.vimsettings"
  require "tvim.keymaps"
  require "tvim.ui"
end)

MiniDeps.later(function()
  require "tvim.navigation"
  require "tvim.lsp"
  require "tvim.nonels"
  require "tvim.dap"
  vim.cmd "NoNeckPain"
end)
