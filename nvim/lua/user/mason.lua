local M = {
    "williamboman/mason.nvim",
}

M.config = function()
    require("mason").setup()
end

return M
