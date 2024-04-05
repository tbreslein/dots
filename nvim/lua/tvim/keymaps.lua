local M = {
    "folke/which-key.nvim",
    event = "VeryLazy",
}

function M.config()
    local wk = require("which-key")
    wk.setup()
    wk.register({
        Q = { "<nop>", "which_key_ignore" },
        ["<esc>"] = { "<cmd>noh<cr>", "which_key_ignore" },
        [">"] = { ">gv", "which_key_ignore", mode = "v" },
        ["<"] = { "<gv", "which_key_ignore", mode = "v" },
        K = { ":m '<-2<cr>gv=gv", "which_key_ignore", mode = "v" },
        J = { ":m '>+1<cr>gv=gv", "which_key_ignore", mode = "v" },
        P = { '"_dP', "which_key_ignore", mode = "v" },
        Y = { "yg$", "which_key_ignore" },
        J = { "mzJ`z", "which_key_ignore" },
        x = { '"_x', "which_key_ignore", mode = { "n", "v", "x" } },
        ["<c-d>"] = { "<c-d>zz", "which_key_ignore", mode = { "n", "v" } },
        ["<c-u>"] = { "<c-u>zz", "which_key_ignore", mode = { "n", "v" } },
        n = { "nzzzv", "which_key_ignore", mode = { "n", "v" } },
        N = { "Nzzzv", "which_key_ignore", mode = { "n", "v" } },
        k = { "v:count == 0 ? 'gk' : 'k'", expr = true },
        j = { "v:count == 0 ? 'gj' : 'j'", expr = true },
        ["<leader>"] = {
            w = { "<cmd>w<cr>", "which_key_ignore", silent = false },
            r = { '"hy:%s/<c-r>h//g<left><left>', "replace", silent = false },
            y = { '"+y', "which_key_ignore", mode = { "n", "v", "x" } },
            p = { '"+p', "which_key_ignore", mode = { "n", "v", "x" } },
        },
        ["<leader>c"] = {
            name = "quickfix",
            j = { "<cmd>cnext<cr>zz", "cnext" },
            k = { "<cmd>cprev<cr>zz", "cprev" },
            t = {
                function()
                    local qf_exists = false
                    for _, win in pairs(vim.fn.getwininfo()) do
                        if win["quickfix"] == 1 then
                            qf_exists = true
                            break
                        end
                    end
                    if qf_exists == true then
                        return vim.cmd("cclose")
                    end
                    if not vim.tbl_isempty(vim.fn.getqflist()) then
                        return vim.cmd("copen")
                    end
                end,
                "ctoggle",
            },
        },
    })
end

return M
