local M = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = "nvim-lua/plenary.nvim",
}

function M.config()
  local harpoon = require "harpoon"
  harpoon.setup { settings = { save_on_toggle = true } }

  kmap("n", "<m-u>", function()
    harpoon:list():select(1)
  end)
  kmap("n", "<m-i>", function()
    harpoon:list():select(2)
  end)
  kmap("n", "<m-o>", function()
    harpoon:list():select(3)
  end)
  kmap("n", "<m-p>", function()
    harpoon:list():select(4)
  end)
  kmap("n", "<m-y>", function()
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
