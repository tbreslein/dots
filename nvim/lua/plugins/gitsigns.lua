require("gitsigns").setup()
require("which-key").register({
    ["<leader>g"] = {
        name = "+git",
        ["<space>"] = { "<cmd>Git<space>", "...", silent = false },
        g = { "<cmd>Git<cr>", "status" },
        G = { "<cmd>Telescope git_status<cr>", "Telescope status" },
        ["p<space>"] = { "<cmd>Git pull<space>", "pull ...", silent = false },
        p = { "<cmd>Git pull<cr>", "pull" },
        P = {
            name = "+push",
            ["<space>"] = { "<cmd>Git push<space>", "...", silent = false },
            P = { "<cmd>Git push<cr>", "push" },
            F = { "<cmd>Git push --force-with-lease<cr>", "force with lease" },
            U = { "<cmd>Git push --set-upstream- origin<cr>", "set upstream origin" },
        },
        l = { "<cmd>Git log<cr>", "log" },
        s = { "<cmd>Telescope git_branches<cr>", "switch" },
        B = { "<cmd>Git checkout -b<space>", "checkout -b ..." },
        m = {
            name = "+merge",
            ["<space>"] = { "<cmd>Git merge<space>", "...", silent = false },
            d = { "<cmd>Gvdiffsplit!<cr>", "diff split" },
            h = { "<cmd>diffget //2<cr>", "diffget left" },
            l = { "<cmd>diffget //3<cr>", "diffget right" },
        },
    },
})
