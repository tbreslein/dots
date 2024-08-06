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

local pick = require "mini.pick"
pick.setup()
map("n", "<leader>ff", pick.builtin.files, "pick files")
map("n", "<leader>fs", pick.builtin.grep_live, "pick live grep")

map("n", "<m-s>", function()
  miniextra.pickers.visit_paths { filter = "todo" }
end, "pick todo labels")

map("n", "<m-a>", function()
  minivisits.add_label "todo"
end, "add todo label")

map("n", "<m-A>", function()
  minivisits.remove_label()
end, "remove todo label")

map("n", "<leader>gc", function()
  miniextra.pickers.git_commits()
end, "pick git commits")

map("n", "<leader>gh", function()
  miniextra.pickers.git_hunks()
end, "pick git hunks")

local files = require "mini.files"
files.setup()
map("n", "<leader>fo", files.open, "open file explorer")
