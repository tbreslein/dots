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
  local dropdown = require("telescope.themes").get_dropdown {}
  telescope.setup()
  telescope.load_extension "undo"
  telescope.load_extension "zf-native"

  kmap("n", "<leader>ff", function()
    vim.fn.system "git rev-parse --is-inside-work-tree"
    if vim.v.shell_error == 0 then
      builtin.git_files(dropdown)
    else
      builtin.find_files(dropdown)
    end
  end)
  kmap("n", "<leader>fg", function()
    builtin.git_files(dropdown)
  end)
  kmap("n", "<leader>fs", function()
    builtin.live_grep(dropdown)
  end)
  kmap("n", "<leader>u", ":Telescope undo<cr>")
end

return M
