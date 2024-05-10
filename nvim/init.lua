require("user.core")
require("user.options")
spec("user.colorscheme")
spec("user.treesitter")
spec("user.lualine")
spec("user.git")
spec("user.neorg")
spec("user.navigation")
spec("user.tools")

-- load these last!
require("user.lazy")
require("user.keymaps")
