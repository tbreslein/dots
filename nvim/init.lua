require "user.core"
require "user.options"
require "user.keymaps"

spec "luarocks" -- neorg needs this
spec "neorg"
spec "colorscheme"
spec "treesitter"
spec "heirline"

spec "telescope"
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
