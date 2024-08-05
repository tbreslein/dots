local M = {
  "ggandor/leap.nvim",
}

function M.config()
  kmap("n", "s", "<Plug>(leap)")
end

return M
