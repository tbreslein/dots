vim.g.mapleader = " "
require("tvim.core")
require("tvim.vim-settings")
spec("tvim.common-deps")
spec("tvim.colourscheme")
spec("tvim.keymaps")
spec("tvim.tree-sitter")
spec("tvim.statusline")
spec("tvim.git")
spec("tvim.editing")
spec("tvim.lang-tools")
require("tvim.lazy")

vim.cmd([[hi FlashCursor ctermfg=blue]])
