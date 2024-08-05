local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "natecraddock/telescope-zf-native.nvim",
    "debugloop/telescope-undo.nvim",
  },
}

function M.config()
  local telescope = require "telescope"
  local builtin = require "telescope.builtin"
  telescope.setup()
  telescope.load_extension "undo"
  telescope.load_extension "zf-native"

  local layout_defaults =
    { layout_strategy = "vertical", layout_config = { width = 0.8 } }

  kmap("n", "<leader>ff", function()
    vim.fn.system "git rev-parse --is-inside-work-tree"
    if vim.v.shell_error == 0 then
      builtin.git_files(layout_defaults)
    else
      builtin.find_files(layout_defaults)
    end
  end)
  kmap("n", "<leader>fg", function()
    builtin.git_files(layout_defaults)
  end)
  kmap("n", "<leader>fs", function()
    builtin.live_grep(layout_defaults)
  end)
  kmap("n", "<leader>u", ":Telescope undo<cr>")
  kmap("n", "<leader>gs", function()
    builtin.git_branches(layout_defaults)
  end)
end

return M
