local M = {
  "nvim-neorg/neorg",
  dependencies = "luarocks.nvim",
  lazy = false,
  version = "*",
}

function M.config()
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
end

return M
