vim.g.mapleader = " "
require("tvim.core")
require("tvim.vim-settings")
spec("tvim.common-deps")
spec("tvim.colourscheme")
spec("tvim.keymaps")
spec("tvim.tree-sitter")
require("tvim.lazy")

-- move these somewhere else
vim.g.my_obsidian_vault = os.getenv("HOME") .. "/syncthing/notes/vault"
vim.g.my_dotfiles = os.getenv("HOME") .. "/dotfiles"
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})

vim.cmd([[hi FlashCursor ctermfg=blue]])
