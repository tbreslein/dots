require "user.core"
require "user.options"

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

-- require these last
require "user.lazy"
