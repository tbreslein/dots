require("user.core")
require("user.options")

-- UI
spec("user.colorscheme")
spec("user.treesitter")
spec("user.lualine")
spec("user.git")
spec("user.fidget")

-- navigation
spec("user.telescope")
spec("user.harpoon")
spec("user.flash")
spec("user.oil")
spec("user.nvim-tmux-navigation")

-- editing
spec("user.neorg")
spec("user.mason")
spec("user.null-ls")

-- load these last!
require("user.lazy")
require("user.keymaps")
