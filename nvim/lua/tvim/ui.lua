-- COLORS / UI / TREESITTER
add "sainnhe/gruvbox-material"
vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
vim.g.gruvbox_material_dim_inactive_windows = 1
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_transparent_background = 1
vim.g.gruvbox_material_ui_contrast = "high"
vim.g.gruvbox_material_better_performance = 1
vim.cmd.colorscheme "gruvbox-material"

require("mini.git").setup {}
require("mini.diff").setup {
  view = {
    style = "sign",
    signs = { add = "|", change = "|", delete = "|" },
  },
}
require("mini.icons").setup {}
require("mini.statusline").setup {
  content = {
    active = function()
      local st = require "mini.statusline"
      local mode, mode_hl = st.section_mode { trunc_width = 120 }
      local git = st.section_git { trunc_width = 40 }
      local diff = st.section_diff { trunc_width = 75 }
      local diagnostics = st.section_diagnostics { trunc_width = 75 }
      local filename = st.section_filename { trunc_width = 140 }
      local location = st.section_location { trunc_width = 75 }
      local search = st.section_searchcount { trunc_width = 75 }

      return st.combine_groups {
        { hl = mode_hl, strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { git, diff } },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=", -- End left alignment
        { hl = "MiniStatuslineDevinfo", strings = { diagnostics } },
        { hl = mode_hl, strings = { search, location } },
      }
    end,
  },
}

add {
  source = "nvim-treesitter/nvim-treesitter",
  hooks = {
    post_checkout = function()
      vim.cmd ":TSUpdate"
    end,
  },
}
require("nvim-treesitter.configs").setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = { "json" },
  },
  indent = { enable = true },
  autotag = { enable = true },
}
add "nvim-treesitter/nvim-treesitter-context"
add "nvim-treesitter/nvim-treesitter-textobjects"
require("treesitter-context").setup { multiline_threshold = 2 }
require("nvim-treesitter.configs").setup {
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}
require("mini.notify").setup()
