return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "debugloop/telescope-undo.nvim",
        },
        config = function()
            require("telescope").setup({
                defaults = { layout_config = { vertical = 0.8 } },
            })
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("undo")
        end,
    },
    { "theprimeagen/harpoon", branch = "harpoon2", opts = { settings = { save_on_toggle = true } } },
    { "folke/flash.nvim", opts = {} },
    {
        "stevearc/oil.nvim",
        opts = {
            keymaps = {
                ["<c-s>"] = false,
                ["<c-h>"] = false,
                ["<c-v>"] = "actions.select_vsplit",
                ["<c-x>"] = "actions.select_split",
            },
        },
    },
    {
        "epwalsh/obsidian.nvim",
        opts = {
            workspaces = {
                { name = "notes", path = vim.g.my_obsidian_vault },
            },
            mappings = {
                ["<leader>tt"] = {
                    action = function()
                        return require("obsidian").util.toggle_checkbox()
                    end,
                    opts = { buffer = true },
                },
            },
        },
    },
    {
        "alexghergh/nvim-tmux-navigation",
        opts = {
            disable_when_zoomed = true, -- defaults to false
            keybindings = {
                left = "<C-h>",
                down = "<C-j>",
                up = "<C-k>",
                right = "<C-l>",
                last_active = "<C-\\>",
                next = "<C-Space>",
            },
        },
    },
}
