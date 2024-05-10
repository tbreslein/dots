local M = {
    "williamboman/mason.nvim",
    dependencies = "RubixDev/mason-update-all",
}

M.config = function()
    require("mason").setup()
    require("mason-update-all").setup()
end

return M
