local M = {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

function M.config()
  require("oil").setup({
    keymaps = {
      ["<c-s>"] = false,
      ["<c-h>"] = false,
      ["<c-v>"] = "actions.select_vsplit",
      ["<c-x>"] = "actions.select_split",
    },
  })
  kmap("n", "<leader>fo", ":Oil<cr>")
end

return M
