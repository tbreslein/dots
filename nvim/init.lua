require "user.core"
require "user.options"

spec "luarocks" -- neorg needs this
spec "neorg"
spec "colorscheme"
spec "treesitter"
spec "telescope"
spec "oil"
spec "harpoon"
spec "mason"
spec "formatter"

-- require these last
require "user.lazy"
