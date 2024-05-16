local telescope = require("telescope")
local builtin = require("telescope.builtin")
local dropdown require("telescope.themes").get_dropdown({})
telescope.setup()
telescope.load_extension("undo")
telescope.load_extension("zf-native")

require("which-key").register({
    ["<leader>f"] = {
        name = "+file",
        f = { function()
            vim.fn.system("git rev-parse --is-inside-work-tree")
            if vim.v.shell_error == 0 then
                builtin.git_files(dropdown)
            else
                builtin.find_files(dropdown)
            end
        end, "find files" },
        g = { function() builtin.git_files(dropdown) end, "git files" },
        s = { function() builtin.live_grep(dropdown) end, "live grep" },
    },
    ["<leader>u"] = { "<cmd>Telescope undo<cr>", "telescope undo" },
})
