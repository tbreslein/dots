vim.g.mapleader = " "

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local builtin = require("telescope.builtin")
local dap = require("dap")
local dapui = require("dapui")
local dappython = require("dap-python")

local project_files = function()
    vim.fn.system("git rev-parse --is-inside-work-tree")
    if vim.v.shell_error == 0 then
        builtin.git_files()
    else
        builtin.find_files()
    end
end

require("legendary").setup({
    keymaps = {
        { ">", ">gv", description = "indent right", mode = { "v" } },
        { "<", "<gv", description = "indent left", mode = { "v" } },
        { "Y", "yg$", description = "yank to end of line", mode = { "n" } },
        { "J", ":m '>+1<cr>gv=gv'", description = "move visual block down", mode = { "v" } },
        { "K", ":m '<-2<cr>gv=gv'", description = "move visual block up", mode = { "v" } },
        { "J", "mzJ`z", description = "join lines without moving cursor", mode = { "n" } },
        { "<c-d>", "<c-d>zz", description = "scroll half page down and recenter", mode = { "n" } },
        { "<c-u>", "<c-u>zz", description = "scroll half page up and recenter", mode = { "n" } },
        { "n", "nzzzv", description = "jump to next match and recenter", mode = { "n" } },
        { "N", "Nzzzv", description = "jump to prev match and recenter", mode = { "n" } },
        { "P", [["_dP]], description = "paste without losing register", mode = { "v" } },
        { "Q", "<nop>", description = "remove Q keybind", mode = { "n" } },
        { "<c-b>", "<cmd>cnext<cr>zz", description = "next in quickfix list", mode = { "n" } },
        { "<c-f>", "<cmd>cprev<cr>zz", description = "prev in quickfix list", mode = { "n" } },
        { "<leader>j", "<cmd>lprev<cr>zz", description = "prev in loclist", mode = { "n" } },
        { "<leader>k", "<cmd>lnext<cr>zz", description = "next in loclist", mode = { "n" } },
        {
            "s",
            function()
                require("flash").jump()
            end,
            decription = "flash",
            mode = { "n", "x", "o" },
        },
        {
            "S",
            function()
                require("flash").treesitter()
            end,
            decription = "flash treesitter",
            mode = { "n", "o", "x" },
        },
        {
            "<leader>y",
            '"+y',
            description = "yank into system clipboard",
            mode = { "n", "v" },
        },
        {
            "<leader>Y",
            '"+Y',
            description = "yank to end of line into system clipboard",
            mode = { "n" },
        },
        {
            "<leader>S",
            ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
            description = "search and replace word under cursor",
            mode = { "n", "v" },
        },
        {
            "jk",
            "<c-\\><c-n>",
            description = "leave insert mode in embedded terminal",
            mode = { "t" },
        },
        { "<leader>a", mark.add_file, description = "add harpoon mark", mode = { "n" } },
        {
            "<c-e>",
            ui.toggle_quick_menu,
            description = "toggle harpoon quick menu",
            mode = { "n" },
        },
        {
            "<m-u>",
            function()
                ui.nav_file(1)
            end,
            description = "nav to harpoon mark 1",
            mode = { "n" },
        },
        {
            "<m-i>",
            function()
                ui.nav_file(2)
            end,
            description = "nav to harpoon mark 2",
            mode = { "n" },
        },
        {
            "<m-o>",
            function()
                ui.nav_file(3)
            end,
            description = "nav to harpoon mark 3",
            mode = { "n" },
        },
        {
            "<m-p>",
            function()
                ui.nav_file(4)
            end,
            description = "nav to harpoon mark 4",
            mode = { "n" },
        },
        {
            "<m-y>",
            function()
                ui.nav_file(5)
            end,
            description = "nav to harpoon mark 5",
            mode = { "n" },
        },
        {
            "<leader>u",
            "<cmd>UndotreeToggle<cr>",
            description = "toggle undo tree",
            mode = { "n" },
        },
    },
    which_key = { auto_register = true },
})

require("which-key").register({
    p = {
        name = "project",
        f = { project_files, "find files respecting gitignore" },
        F = { "<cmd>Telescope find_files hidden=true<cr>", "find files, including hidden files" },
        s = { builtin.live_grep, "live grep" },
        p = { "<cmd>lua MiniFiles.open()<cr>", "project view" },
    },
    t = {
        name = "terminal",
        h = { "<cmd>ToggleTerm direction=horizontal<cr>", "toggleterm horizontal" },
        j = { "<cmd>ToggleTerm direction=horizontal<cr>", "toggleterm vertical" },
        t = { "<cmd>ToggleTerm direction=float<cr>", "toggleterm float" },
    },
    c = { "<cmd>lua vim.lsp.buf.clear_references()<cr>", "clear highlight references" },
    m = { require("muren.api").toggle_ui, "toggle muren" },
}, {
    prefix = "<leader>",
})

require("gitsigns").setup({
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        require("which-key").register({
            g = {
                name = "git",
                g = {
                    function()
                        require("neogit").open({ kind = "split" })
                    end,
                    "open neogit",
                },
                c = {
                    function()
                        require("neogit").open({ "commit" })
                    end,
                    "open neogit commit popup",
                },
                s = { gs.stage_hunk, "stage hunk under cursor" },
                r = { gs.reset_hunk, "reset hunk under cursor" },
                S = { gs.stage_buffer, "stage everything in buffer" },
                u = { gs.undo_stage_buffer, "undo stage buffer" },
                R = { gs.reset_buffer, "reset buffer" },
                P = { gs.preview_hunk, "preview hunk" },
                b = { gs.toggle_current_line_blame, "toggle blame" },
                d = { gs.diff_this, "diff" },
                D = { gs.toggle_deleted, "diff" },
                p = {
                    function()
                        if vim.wo.diff then
                            return "<leader>"
                        end
                        vim.schedule(gs.prev_hunk)
                        return "<Ignore>"
                    end,
                    "prev hunk",
                },
                n = {
                    function()
                        if vim.wo.diff then
                            return "<leader>"
                        end
                        vim.schedule(gs.next_hunk)
                        return "<Ignore>"
                    end,
                    "next hunk",
                },
            },
        }, {
            prefix = "<leader>",
            mode = "n",
        })
        require("which-key").register({
            g = {
                name = "git",
                s = {
                    function()
                        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end,
                    "stage selected hunk",
                },
                r = {
                    function()
                        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end,
                    "reset selected hunk",
                },
            },
        }, {
            prefix = "<leader>",
            mode = "v",
        })
    end,
})
