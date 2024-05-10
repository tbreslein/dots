local M = {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    dependencies = { "vhyrro/luarocks.nvim", priority = 1000, opts = {} },
}

function M.config()
    require("neorg").setup({
        load = {
            ["core.defaults"] = {},
            ["core.concealer"] = {},
            ["core.dirman"] = {
                config = {
                    workspaces = { notes = "~/syncthing/notes" },
                    default_workspace = "notes"
                }
            },
        }
    })
end

return M
