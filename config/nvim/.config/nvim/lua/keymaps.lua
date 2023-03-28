vim.g.mapleader = " "

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local builtin = require("telescope.builtin")

-- leap defaults
require("leap").add_default_mappings()

require("legendary").setup({
    keymaps = {
        {
            "j",
            "gj",
            description = "move between down wrapped lines",
            mode = { "n",
                "v" }
        },
        {
            "k",
            "gk",
            description = "move between up wrapped lines",
            mode = { "n",
                "v" }
        },
        { ">",         ">gv",               description = "indent right",                       mode = { "v" } },
        { "<",         "<gv",               description = "indent left",                        mode = { "v" } },
        { "Y",         "yg$",               description = "yank to end of line",                mode = { "n" } },
        { "J",         ":m '>+1<cr>gv=gv'", description = "move visual block down",             mode = { "v" } },
        { "K",         ":m '<-2<cr>gv=gv'", description = "move visual block up",               mode = { "v" } },
        { "J",         "mzJ`z",             description = "join lines without moving cursor",   mode = { "n" } },
        { "<c-d>",     "<c-d>zz",           description = "scroll half page down and recenter", mode = { "n" } },
        { "<c-u>",     "<c-u>zz",           description = "scroll half page up and recenter",   mode = { "n" } },
        { "n",         "nzzzv",             description = "jump to next match and recenter",    mode = { "n" } },
        { "N",         "Nzzzv",             description = "jump to prev match and recenter",    mode = { "n" } },
        { "P",         "_dP",               description = "pase without losing register",       mode = { "v" } },
        { "Q",         "<nop>",             description = "remove Q keybind",                   mode = { "n" } },
        { "<c-k>",     "<cmd>cnext<cr>zz",  description = "next in quickfix list",              mode = { "n" } },
        { "<c-j>",     "<cmd>cprev<cr>zz",  description = "prev in quickfix list",              mode = { "n" } },
        { "<leader>j", "<cmd>lprev<cr>zz",  description = "prev in loclist",                    mode = { "n" } },
        { "<leader>k", "<cmd>lnext<cr>zz",  description = "next in loclist",                    mode = { "n" } },
        {
            "<leader>y",
            '"+y',
            description = "yank into system clipboard",
            mode = { "n",
                "v" }
        },
        { "<leader>Y", '"+Y', description = "yank to end of line into system clipboard",   mode = { "n" } },
        {
            "<leader>d",
            '"+d',
            description = "delete into system clipboard",
            mode = { "n",
                "v" }
        },
        { "<leader>D", '"+D', description = "delete to end of line into system clipboard", mode = { "n" } },
        {
            "<leader>S",
            ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
            description = "search and replace word under cursor",
            mode = { "n" },
        },
        {
            "<leader>S",
            ":s/\\(\\)<Left><Left>",
            description = "search and replace word under cursor",
            mode = { "v" },
        },
        { "jk",        "<c-\\><c-n>",        description = "leave insert mode in embedded terminal", mode = { "t" } },
        {
            "<leader>zz",
            function()
                require("zen-mode").toggle()
                vim.wo.wrap = false
            end,
            description = "delete to end of line into system clipboard",
            mode = { "n" },
        },
        { "<leader>a", mark.add_file,        description = "add harpoon mark",                       mode = { "n" } },
        { "<c-e>",     ui.toggle_quick_menu, description = "toggle harpoon quick menu",              mode = { "n" } },
        {
            "<a-u>",
            function()
                ui.nav_file(1)
            end,
            description = "nav to harpoon mark 1",
            mode = { "n" },
        },
        {
            "<a-i>",
            function()
                ui.nav_file(2)
            end,
            description = "nav to harpoon mark 2",
            mode = { "n" },
        },
        {
            "<a-o>",
            function()
                ui.nav_file(3)
            end,
            description = "nav to harpoon mark 3",
            mode = { "n" },
        },
        {
            "<a-p>",
            function()
                ui.nav_file(4)
            end,
            description = "nav to harpoon mark 4",
            mode = { "n" },
        },
        { "<leader>u",  "<cmd>UndotreeToggle<cr>", description = "toggle undo tree", mode = { "n" } },
        { "<leader>t",  "<cmd>TroubleToggle<cr>",  description = "toggle trouble",   mode = { "n" } },
        { "<leader>rn", ":IncRename ",             description = "start increname",  mode = { "n" } },
    },
    which_key = { auto_register = true },
})

require("which-key").register({
    p = {
        name = "project",
        f = { "<cmd>Telescope find_files hidden=true<cr>", "find files" },
        F = { builtin.git_files, "find files in git mode" },
        g = { builtin.live_grep, "live grep" },
        v = { "<cmd>Telescope file_browser<cr>", "project view" },
        b = { "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", "project view at current buffer" },
    },
    s = {
        name = "spectre",
        s = { "<cmd>lua require('spectre').open()<cr>", "open spectre" },
        w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "open spectre for word under cursor" },
        f = { "<cmd>lua require('spectre').open_file_search()<cr>", "open spectre in file search mode" },
    },
}, {
    prefix = "<leader>",
})
