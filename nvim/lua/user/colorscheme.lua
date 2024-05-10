local M = {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
}

M.config = function()
    vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
    vim.g.gruvbox_material_dim_inactive_windows = 1
    vim.g.gruvbox_material_transparent_background = 1
    vim.g.gruvbox_material_ui_contrast = "high"
    vim.cmd("colorscheme gruvbox-material")
end

return M
