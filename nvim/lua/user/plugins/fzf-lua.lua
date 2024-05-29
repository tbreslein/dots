local M = {
  "ibhagwan/fzf-lua",
  dependencies = "nvim-tree/nvim-web-devicons",
}

function M.config()
  local fzflua = require "fzf-lua"
  -- local actions = require "fzf-lua.actions"
  fzflua.setup {
    winopts = {
      preview = {
        layout = "vertical",
        vertical = "up:70%",
      },
    },
    -- actions = {
    --   files = { ["ctrl-s"] = actions.file_split },
    -- },
  }

  kmap("n", "<leader>ff", function()
    vim.fn.system "git rev-parse --is-inside-work-tree"
    if vim.v.shell_error == 0 then
      fzflua.git_files()
    else
      fzflua.files()
    end
  end)
  kmap("n", "<leader>fg", fzflua.git_files)
  kmap("n", "<leader>fs", fzflua.live_grep)
  kmap("n", "<leader>gs", fzflua.git_branches)
  -- kmap("n", "<leader>gs", function()
  --   builtin.git_branches(layout_defaults)
  -- end)
end

return M
