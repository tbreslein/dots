local M = {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons"
}

function M.config()
    require("lualine").setup({
        options = { component_separators = "", section_separators = "" },
        sections = {
            lualine_a = { "mode" },
            -- lualine_b = {},
            lualine_b = { "branch", "diff" },
            lualine_c = { { "filename", path = 3 } },
            lualine_x = { "diagnostics" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
    })
end

return M
