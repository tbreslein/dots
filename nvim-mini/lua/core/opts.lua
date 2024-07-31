local opt = vim.opt
local g = vim.g
local opts = {}

opts.initial = function()
  g.mapleader = " "
  g.maplocalleader = ","

  opt.laststatus = 0
  opt.guicursor = ""
  opt.nu = true
  opt.relativenumber = true
  opt.colorcolumn = "80"
  opt.termguicolors = true
  opt.signcolumn = "yes"
  opt.smartindent = true
  opt.isfname:append "@-@"
  opt.completeopt = { "menu", "menuone", "noselect" }
  opt.foldenable = false
  opt.conceallevel = 0
  opt.swapfile = false
  opt.backup = false
  opt.undodir = os.getenv "HOME" .. "/.local/share/vim/undodir"
  opt.undofile = true
  opt.linebreak = true
  opt.mouse = "a"
  opt.fileencoding = "utf-8"
  opt.clipboard:append { "unnamed", "unnamedplus" }
  opt.laststatus = 3
  opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
  opt.fillchars = { eob = " " }
  opt.inccommand = "split"
  opt.autoread = true

  g.netrw_banner = 0
  g.netrw_mouse = 2

  g.my_notes = os.getenv "HOME" .. "/notes"
  g.my_dotfiles = os.getenv "HOME" .. "/dots"

  if vim.loop.os_uname().sysname == "Darwin" then
    vim.fn.setenv("CC", "gcc-14")
    vim.fn.setenv("CXX", "g++-14")
  end
end

opts.final = function()
  opt.complete = {}
  opt.list = true
  opt.wildmenu = true
  opt.pumheight = 20
  opt.ignorecase = true
  opt.smartcase = true
  opt.timeout = false
  opt.updatetime = 400
  opt.splitbelow = true
  opt.splitright = true
  opt.scrolloff = 4
  -- local statusline_ascii = ""
  -- opt.statusline = "%#Normal#" .. statusline_ascii .. "%="
  -- opt.cmdheight = 0
end

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

vim.diagnostic.config {
  virtual_text = {
    prefix = "",
    suffix = "",
  },
  underline = {
    severity = { min = vim.diagnostic.severity.WARN },
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

return opts
