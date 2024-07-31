local M = {}

M.bootstrap = function()
  local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "--branch=stable",
      lazyrepo,
      lazypath,
    }
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(lazypath)
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

return M
