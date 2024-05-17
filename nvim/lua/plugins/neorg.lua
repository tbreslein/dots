require("neorg").setup({
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.completion"] = {
            config = { engine = "nvim-cmp" },
        },
        ["core.esupports.metagen"] = { config = { type = "auto", undojoin_updates = false } },
        ["core.integrations.nvim-cmp"] = {},
        ["core.summary"] = {},
        ["core.dirman"] = {
            config = {
                workspaces = {
                    notes = "~/notes",
                },
                default_workspace = "notes",
            },
        },
    },
})
