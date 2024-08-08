add "sainnhe/gruvbox-material"
vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
vim.g.gruvbox_material_dim_inactive_windows = 1
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_transparent_background = 1
vim.g.gruvbox_material_ui_contrast = "high"
vim.g.gruvbox_material_better_performance = 1
vim.cmd.colorscheme "gruvbox-material"

local hipatterns = require "mini.hipatterns"
hipatterns.setup {
  highlighters = { hex_color = hipatterns.gen_highlighter.hex_color() },
}

add "tpope/vim-fugitive"
map("n", "<leader>gg", ":Git<cr>4j", "Git")
map("n", "<leader>ga", ":Git add .<cr>", "Git add .")
map("n", "<leader>gc", ":Git commit<cr>", "Git commit")
map("n", "<leader>gC", function()
  vim.cmd "Git add ."
  vim.cmd "Git commit"
  vim.cmd "startinsert"
end, "Git add . && Git commit")
map("n", "<leader>gPP", ":Git push<cr>", "Git push")
map("n", "<leader>gf", ":Git fetch<cr>", "Git fetch")

require("mini.diff").setup {
  view = { style = "sign", signs = { add = "|", change = "|", delete = "|" } },
}

add {
  source = "nvim-lualine/lualine.nvim",
  depends = { "nvim-tree/nvim-web-devicons" },
}
require("lualine").setup {
  options = {
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff" },
    lualine_c = { "diagnostics" },
    lualine_x = {},
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  winbar = {
    lualine_a = {},
    lualine_b = { { "filename", path = 3 } },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 3 } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
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

add {
  source = "OXY2DEV/markview.nvim",
  depends = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
}
require("markview").setup {
  modes = { "n", "no", "i", "c" },
  hybrid_modes = { "i" },
}

add "akinsho/toggleterm.nvim"
local toggleterm = require "toggleterm"
toggleterm.setup {}
map("n", "<leader>tt", ":ToggleTerm size=20<cr>", "toggleterm")
map("n", "<leader>te", ":TermExec cmd='!!'<cr>", "toggleterm")

add "shortcuts/no-neck-pain.nvim"
require("no-neck-pain").setup { width = 140 }
map("n", "<leader>zz", ":NoNeckPain<cr>", "toggle no-neck-pain")
