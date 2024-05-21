require "user.core"
require "user.options"

spec "luarocks" -- neorg needs this
spec "colorscheme"
spec "treesitter"
spec "telescope"
spec "oil"
spec "harpoon"

-- require these last
require "user.lazy"
