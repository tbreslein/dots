local M = {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "debugloop/telescope-undo.nvim",
        },
    },
    { "theprimeagen/harpoon", branch = "harpoon2" },
    "folke/flash.nvim",
    "stevearc/oil.nvim",
    "epwalsh/obsidian.nvim",
    "alexghergh/nvim-tmux-navigation",
}

function M.config()
    require("telescope").setup({ defaults = { layout_config = { vertical = 0.8 } } })
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("undo")

    require("harpoon").setup({ settings = { save_on_toggle = true } })
    require("flash").setup({})
    require("oil").setup({
        keymaps = {
            ["<c-s>"] = false,
            ["<c-h>"] = false,
            ["<c-v>"] = "actions.select_vsplit",
            ["<c-x>"] = "actions.select_split",
        },
    })

    require("obsidian").setup({ workspaces = { { name = "notes", path = vim.g.my_obsidian_vault } } })

    require("nvim-tmux-navigation").setup({
        disable_when_zoomed = true, -- defaults to false
        keybindings = {
            left = "<C-h>",
            down = "<C-j>",
            up = "<C-k>",
            right = "<C-l>",
            last_active = "<C-\\>",
            next = "<C-Space>",
        },
    })

    require("which-key").register({
        ["<leader>u"] = { "<cmd>Telescope undo<cr>", "open undotree" },
        ["<leader>f"] = {
            name = "files",
            f = {
                function()
                    vim.fn.system("git rev-parse --is-inside-work-tree")
                    if vim.v.shell_error == 0 then
                        require("telescope.builtin").git_files()
                    else
                        require("telescope.builtin").find_files()
                    end
                end,
                "find",
            },
            g = { require("telescope.builtin").git_files, "git files" },
            s = { require("telescope.builtin").live_grep, "live grep" },
            o = { require("oil").toggle_float, "open file browser" },
            e = {
                function()
                    if string.sub(vim.uv.cwd(), 1, string.len(vim.g.my_dotfiles)) == vim.g.my_dotfiles then
                        require("telescope.builtin").find_files()
                    else
                        vim.cmd("silent !tmux new-window -c " .. vim.g.my_dotfiles .. [[ nvim "+Telescope git_files"]])
                    end
                end,
                "fzf in dotfiles",
            },
        },
        ["<leader>a"] = {
            function()
                require("harpoon"):list():add()
            end,
            "harpoon append",
        },
        ["<leader>e"] = {
            function()
                require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
            end,
            "harpoon list",
        },
    })
end

return M
