local M = {
    {
        "nvim-telescope/telescope.nvim", dependencies = {
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "debugloop/telescope-undo.nvim",
            "nvim-lua/plenary.nvim",
        }
    },

    { "theprimeagen/harpoon", branch = "harpoon2" , dependencies = "nvim-lua/plenary.nvim", },

    "folke/flash.nvim",
    "stevearc/oil.nvim",

    "alexghergh/nvim-tmux-navigation",
}

function M.config()
    local t = require("telescope")
    t.setup({ defaults = { layout_config = { vertical = 0.8 } }, })
    t.load_extension("fzf")
    t.load_extension("undo")

    require("harpoon").setup({ settings = { save_on_toggle = true } })

    require("flash").setup({})

    require("oil").setup({
        keymaps = {
            ["<c-s>"] = false,
            ["<c-h>"] = false,
            ["<c-v>"] = "actions.select_vsplit",
            ["<c-x>"] = "actions.select_split",
        }
    })

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
