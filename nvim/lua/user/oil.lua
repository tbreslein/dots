local M = {
    "stevearc/oil.nvim",
}

M.config = function()
    require("oil").setup({
        keymaps = {
            ["<c-s>"] = false,
            ["<c-h>"] = false,
            ["<c-v>"] = "actions.select_vsplit",
            ["<c-x>"] = "actions.select_split",
        },
    })
end

return M
