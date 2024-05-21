local M = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" }
}

function M.config()
  local harpoon = require("harpoon")
  harpoon.setup({ settings = { save_on_toggle = true } })

  kmap("n", "<m-6>", function() harpoon:list():select(1) end)
  kmap("n", "<m-7>", function() harpoon:list():select(2) end)
  kmap("n", "<m-8>", function() harpoon:list():select(3) end)
  kmap("n", "<m-9>", function() harpoon:list():select(4) end)
  kmap("n", "<m-0>", function() harpoon:list():select(5) end)
  kmap("n", "<leader>a", function() harpoon:list():add() end)
  kmap("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
end

return M
