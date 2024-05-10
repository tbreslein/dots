local M = {
    "alexghergh/nvim-tmux-navigation",
}

M.config = function()
    require("nvim-tmux-navigation").setup({
        disable_when_zoomed = true,
        keybindings = {
            left = "<c-h>",
            down = "<c-j>",
            up = "<c-k>",
            right = "<c-l>",
            last_active = "<c-\\>",
            next = "<c-Space>",
        }
    })
end

return M
