local M = {
    "tpope/vim-fugitive",
    "lewis6991/gitsigns.nvim",
}

function M.config()
    require("gitsigns").setup()
    require("which-key").register({
        ["<leader>g"] = {
            name = "git",
            g = { "<cmd>Git<cr>", "status" },
            ["<space>"] = { ":Git<space>", "...", silent = false },
            G = { "<cmd>Telescope git_status<cr>", "status via Telescope" },
            p = { "<cmd>Git pull<cr>", "pull" },
            P = {
                name = "push",
                ["<space>"] = { ":Git push<space>", "push ...", silent = false },
                P = { "<cmd>Git push<cr>", "regular" },
                U = { "<cmd>Git push --set-upstream origin<cr>", "push -u" },
                F = { "<cmd>Git push --force-with-lease<cr>", "push -u" },
            },
            l = { "<cmd>Git log<cr>", "log" },
            s = { "<cmd>Telescope git_branches<cr>", "checkout/switch" },
            c = {
                name = "commit",
                ["<space>"] = { ":Git commit<space>", "commit ...", silent = false },
                c = { "<cmd>Git commit<cr>", "regular" },
                a = { "<cmd>Git commit --all<cr>", "all" },
                m = { "<cmd>Git commit --amend<cr>", "amend" },
                A = { "<cmd>Git commit --all --amend<cr>", "amend all" },
            },
            m = {
                name = "merge",
                ["<space>"] = { ":Git merge<space>", "merge ...", silent = false },
                d = { "<cmd>Gvdiffsplit!<cr>", "3way diff split" },
                h = { "<cmd>diffget //2<cr>", "diffget left" },
                l = { "<cmd>diffget //3<cr>", "diffget right" },
            },
            B = { ':Git checkout -b<space>""<left>', "checkout -b ...", silent = false },
        },
    })
end

return M
