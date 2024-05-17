require("gitsigns").setup()
require("which-key").register({
    ["<leader>g"] = {
        name = "+git",
        ["<space>"] = { ":Git<space>", "...", silent = false },
        g = { ":Git<cr>", "status" },
        G = { ":Telescope git_status<cr>", "Telescope status" },
        ["p<space>"] = { ":Git pull<space>", "pull ...", silent = false },
        p = { ":Git pull<cr>", "pull" },
        P = {
            name = "+push",
            ["<space>"] = { ":Git push<space>", "...", silent = false },
            P = { ":Git push<cr>", "push" },
            F = { ":Git push --force-with-lease<cr>", "force with lease" },
            U = { ":Git push --set-upstream- origin<cr>", "set upstream origin" },
        },
        l = { ":Git log<cr>", "log" },
        s = { ":Telescope git_branches<cr>", "switch" },
        B = { ":Git checkout -b<space>", "checkout -b ..." },
        m = {
            name = "+merge",
            ["<space>"] = { ":Git merge<space>", "...", silent = false },
            d = { ":Gvdiffsplit!<cr>", "diff split" },
            h = { ":diffget //2<cr>", "diffget left" },
            l = { ":diffget //3<cr>", "diffget right" },
        },
    },
})
