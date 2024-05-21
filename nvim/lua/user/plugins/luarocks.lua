local M = {
    "vhyrro/luarocks.nvim",
    priority = 1000,
}


function M.config()
  require "luarocks".setup()
end

return M
