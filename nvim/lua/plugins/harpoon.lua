local harpoon = require("harpoon")
harpoon.setup({ settings = { save_on_toggle = true } })
require("which-key").register({
  ["<m-6>"] = { function() harpoon:list():select(1) end, "which_key_ignore" },
  ["<m-7>"] = { function() harpoon:list():select(2) end, "which_key_ignore" },
  ["<m-8>"] = { function() harpoon:list():select(3) end, "which_key_ignore" },
  ["<m-9>"] = { function() harpoon:list():select(4) end, "which_key_ignore" },
  ["<m-0>"] = { function() harpoon:list():select(5) end, "which_key_ignore" },
  ["<leader>a"] = { function() harpoon:list():add() end, "harpoon add" },
  ["<leader>e"] = { function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "harpoon list" },
})
