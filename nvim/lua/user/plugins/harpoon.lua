local M = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = "nvim-lua/plenary.nvim",
}

function M.config()
  local harpoon = require "harpoon"
  harpoon.setup { settings = { save_on_toggle = true } }

  kmap("n", "<m-r>", function()
    harpoon:list():select(1)
  end)
  kmap("n", "<m-e>", function()
    harpoon:list():select(2)
  end)
  kmap("n", "<m-w>", function()
    harpoon:list():select(3)
  end)
  kmap("n", "<m-q>", function()
    harpoon:list():select(4)
  end)
  kmap("n", "<m-t>", function()
    harpoon:list():select(5)
  end)
  kmap("n", "<leader>a", function()
    harpoon:list():add()
  end)
  kmap("n", "<leader>e", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end)
end

return M
