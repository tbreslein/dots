local M = {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = "nvim-lua/plenary.nvim",
}

M.config = function()
    require("harpoon").setup({ settings = { save_on_toggle = true } })
end

return M
