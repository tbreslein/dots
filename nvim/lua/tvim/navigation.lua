add {
  source = "ThePrimeagen/harpoon",
  checkout = "harpoon2",
  depends = { "nvim-lua/plenary.nvim" },
}
local harpoon = require "harpoon"
harpoon.setup { settings = { save_on_toggle = true } }
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

local pick = require "mini.pick"
pick.setup()
map("n", "<leader>ff", pick.builtin.files)
map("n", "<leader>fs", pick.builtin.grep_live)
map("n", "<m-s>", function()
  miniextra.pickers.visit_paths { filter = "todo" }
end)

map("n", "<m-a>", function()
  minivisits.add_label "todo"
end)

map("n", "<m-A>", function()
  minivisits.remove_label()
end)

map("n", "<leader>gc", function()
  miniextra.pickers.git_commits()
end)

map("n", "<leader>gh", function()
  miniextra.pickers.git_hunks()
end)

map("n", "<leader>dp", function()
  miniextra.pickers.diagnostic()
end)

local files = require "mini.files"
files.setup()
map("n", "<leader>fo", files.open)
