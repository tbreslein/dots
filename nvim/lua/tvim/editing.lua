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
    "numToStr/Comment.nvim",
    "j-hui/fidget.nvim",
}

local function toggle_todo(x)
    local function replaceAt(str, at, with)
        return string.sub(str, 1, at - 1) .. with .. (string.sub(str, at + 1, string.len(str)))
    end

    local curr_line = vim.api.nvim_get_current_line()
    local _, snd_bckt = string.find(curr_line, "%s*%- %[.%]")
    if snd_bckt == nil then
        return
    end
    local status_idx = snd_bckt - 1
    local status_symbol = string.sub(curr_line, status_idx, status_idx)
    if status_symbol == x then
        vim.api.nvim_set_current_line(replaceAt(curr_line, status_idx, " "))
    else
        vim.api.nvim_set_current_line(replaceAt(curr_line, status_idx, x))
    end
    return
end

function M.config()
    require("telescope").setup({ defaults = { layout_config = { vertical = 0.8 } } })
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("undo")

    require("harpoon").setup({ settings = { save_on_toggle = true } })
    require("flash").setup()
    require("Comment").setup()
    require("fidget").setup()
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
        keybindings = {
            left = "<C-h>",
            down = "<C-j>",
            up = "<C-k>",
            right = "<C-l>",
            last_active = "<C-\\>",
            next = "<C-Space>",
        },
    })

    vim.g.my_obsidian_vault = os.getenv("HOME") .. "/syncthing/notes/vault"
    vim.g.my_dotfiles = os.getenv("HOME") .. "/dotfiles"
    require("which-key").register({
        s = {
            function()
                require("flash").jump()
            end,
            "which_key_ignore",
            mode = { "n", "x", "o" },
        },
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
        ["<m-u>"] = {
            function()
                require("harpoon"):list():select(1)
            end,
            "which_key_ignore",
        },
        ["<m-i>"] = {
            function()
                require("harpoon"):list():select(2)
            end,
            "which_key_ignore",
        },
        ["<m-o>"] = {
            function()
                require("harpoon"):list():select(3)
            end,
            "which_key_ignore",
        },
        ["<m-p>"] = {
            function()
                require("harpoon"):list():select(4)
            end,
            "which_key_ignore",
        },

        ["<leader>n"] = {
            name = "notes",
            n = {
                function()
                    if string.sub(vim.uv.cwd(), 1, string.len(vim.g.my_obsidian_vault)) == vim.g.my_obsidian_vault then
                        vim.cmd("ObsidianQuickSwitch")
                    else
                        vim.cmd(
                            "silent !tmux new-window -c " .. vim.g.my_obsidian_vault .. " nvim +ObsidianQuickSwitch"
                        )
                    end
                end,
                "fzf in notes",
            },
            d = {
                function()
                    if string.sub(vim.uv.cwd(), 1, string.len(vim.g.my_obsidian_vault)) == vim.g.my_obsidian_vault then
                        vim.cmd("e " .. vim.g.my_obsidian_vault .. "/todos.md")
                    else
                        vim.cmd("silent !tmux new-window -c " .. vim.g.my_obsidian_vault .. " nvim todos.md")
                    end
                end,
                "open todos",
            },
        },
        ["<leader>t"] = {
            name = "todos",
            t = "toggle todo checkbox DONE",
            d = {
                function()
                    toggle_todo(">")
                end,
                "toggle todo checkbox DELAYED",
            },
            c = {
                function()
                    toggle_todo("~")
                end,
                "toggle todo checkbox CANCELED",
            },
            o = { "o- [ ] ", "new todo below" },
            O = { "O- [ ] ", "new todo above" },
        },
    })
end

return M
