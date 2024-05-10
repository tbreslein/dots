vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    pattern = "*",
})
vim.api.nvim_create_autocmd("FocusGained", { command = "checktime" })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "fugitive", "git", "help", "lspinfo", "man", "query", "vim" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.rs" },
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})
