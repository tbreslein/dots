add {
  source = "ThePrimeagen/harpoon",
  checkout = "harpoon2",
  depends = { "nvim-lua/plenary.nvim" },
}
local harpoon = require "harpoon"
harpoon.setup { settings = { save_on_toggle = true } }

map("n", "<m-r>", function()
  harpoon:list():select(1)
end, "harpoon select 1")

map("n", "<m-e>", function()
  harpoon:list():select(2)
end, "harpoon select 2")

map("n", "<m-w>", function()
  harpoon:list():select(3)
end, "harpoon select 3")

map("n", "<m-q>", function()
  harpoon:list():select(4)
end, "harpoon select 4")

map("n", "<m-t>", function()
  harpoon:list():select(5)
end, "harpoon select 5")

map("n", "<leader>a", function()
  harpoon:list():add()
end, "harpoon add to list")

map("n", "<leader>e", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, "harpoon toggle quick menu")

add {
  source = "ibhagwan/fzf-lua",
  depends = { "nvim-tree/nvim-web-devicons" },
}
local fzflua = require "fzf-lua"
fzflua.setup {
  winopts = {
    preview = {
      layout = "vertical",
      vertical = "up:70%",
    },
  },
}

map("n", "<leader>ff", function()
  vim.fn.system "git rev-parse --is-inside-work-tree"
  if vim.v.shell_error == 0 then
    fzflua.git_files()
  else
    fzflua.files()
  end
end, "fzf files")
map("n", "<leader>fg", fzflua.git_files, "fzf git_files")
map("n", "<leader>fs", fzflua.live_grep, "fzf live_grep")
map("n", "<leader>gs", fzflua.git_branches, "fzf branches")

local files = require "mini.files"
files.setup()
map("n", "<leader>fo", files.open, "open file explorer")
