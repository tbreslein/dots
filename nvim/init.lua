require "user.core"
require "user.options"
require "user.keymaps"

spec "luarocks" -- neorg needs this
spec "neorg"
spec "colorscheme"
spec "todo-comments"
spec "treesitter"
spec "lualine"

-- spec "telescope"
spec "fzf-lua"
spec "tmux"
spec "oil"
spec "harpoon"
spec "leap"

spec "mason"
spec "formatter"
spec "lint"
spec "dap"
spec "lsp"

spec "gitsigns"
spec "diffview"

-- require these last
require "user.lazy"
