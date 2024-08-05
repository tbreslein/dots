local M = {}

local function clone_paq()
  local path = vim.fn.stdpath "data" .. "/site/pack/paqs/start/paq-nvim"
  local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
  if not is_installed then
    vim.fn.system {
      "git",
      "clone",
      "--depth=1",
      "https://github.com/savq/paq-nvim.git",
      path,
    }
    return true
  end
  return false
end

function M.bootstrap(packages)
  local first_install = clone_paq()
  vim.cmd.packadd "paq-nvim"
  local paq = require "paq"
  if first_install then
    vim.notify "Installing plugins... If prompted, hit Enter to continue."
  end
  paq(packages)
  paq.sync()
end

function M.run_paq(headless)
  if headless then
    vim.cmd "autocmd User PaqDoneInstall quit"
  end
  M.bootstrap {
    "savq/paq-nvim",
    -- List your packages
  }
end

-- Autocommands
function M.autocmds()
  local autocmd = vim.api.nvim_create_autocmd

  vim.b.miniindentscope_disable = true
  autocmd("TermOpen", {
    desc = "Disable 'mini.indentscope' in terminal buffer",
    callback = function(data)
      vim.b[data.buf].miniindentscope_disable = true
    end,
  })
end

function M.map(mode, keys, action, desc)
  desc = desc or ""
  local opts = { noremap = true, silent = true, desc = desc }
  vim.keymap.set(mode, keys, action, opts)
end

return M
