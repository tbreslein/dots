vim.g.mapleader = " "

-- indentation
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- yank to end of line
vim.keymap.set("n", "Y", "yg$")

-- move visual blocks
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")

-- do not move cursor when joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- center cursor vertically after jumping with c-d and c-u, and after seach jumps
vim.keymap.set("n", "<c-d>", "<c-d>zz")
vim.keymap.set("n", "<c-u>", "<c-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- don't lose register when pasting
vim.keymap.set("v", "P", '"_dP')

-- yank to system clipboards (need to be followed up with motions!)
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d')

-- who actually needs Q?
vim.keymap.set("n", "Q", "<nop>")

-- nav through error and quickfix list
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- search and replace the word under the cursor
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- leave insert mode inside terminal mode
vim.keymap.set("t", "jk", "<c-\\><c-n>")
