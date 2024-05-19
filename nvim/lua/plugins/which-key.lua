vim.o.timeout = true
vim.o.timeoutlen = 300

local wk = require("which-key")
-- this is separated into to register calls, because J is set in both tables but
-- for different modes

wk.register({
    Q = { "<nop>", "which_key_ignore" },
    ["<esc>"] = { "<cmd>noh<cr>", "which_key_ignore" },
    jk = { "<c-\\><c-n>", "which_key_ignore", mode = "t" },

    P = { [["_dP]], "which_key_ignore", mode = "v" },
    x = { [["_x]], "which_key_ignore", mode = { "n", "x", "v" } },
    ["<leader>y"] = { [["+y]], "which_key_ignore", mode = { "n", "x", "v" } },
    ["<leader>p"] = { [["+p]], "which_key_ignore", mode = { "n", "x", "v" } },
    Y = { "yg$", "which_key_ignore" },
    J = { "mzJ`z", "which_key_ignore" },

    ["<leader>w"] = { ":w<cr>", "which_key_ignore", silent = false },
    ["<leader>W"] = { ":wq<cr>", "which_key_ignore", silent = false },
    ["<leader>r"] = { [["hy:%s/<c-r>h//g<left><left>]], "search+replace", silent = false },
})

wk.register({
    n = { "nzz", "which_key_ignore" },
    N = { "Nzz", "which_key_ignore" },
    ["*"] = { "*zz", "which_key_ignore" },
    ["#"] = { "#zz", "which_key_ignore" },
    ["g*"] = { "g*zz", "which_key_ignore" },
    ["g#"] = { "g#zz", "which_key_ignore" },
    ["<c-d>"] = { "<c-d>zz", "which_key_ignore", mode = { "n", "v" } },
    ["<c-u>"] = { "<c-u>zz", "which_key_ignore", mode = { "n", "v" } },
    ["<"] = { "<gv", "which_key_ignore", mode = { "v" } },
    [">"] = { ">gv", "which_key_ignore", mode = { "v" } },
    J = { ":m '>+1<cr>gv=gv", "which_key_ignore", mode = { "v" } },
    K = { ":m '<-2<cr>gv=gv", "which_key_ignore", mode = { "v" } },
    j = { "v:count == 0 ? 'gj' : 'j'", "which_key_ignore", expr = true },
    k = { "v:count == 0 ? 'gk' : 'k'", "which_key_ignore", expr = true },

    ["]c"] = { "<cmd>cnext<cr>zz", "which_key_ignore" },
    ["[c"] = { "<cmd>cprev<cr>zz", "which_key_ignore" },
    ["<leader>C"] = {
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
        "toggle qflist",
    },
})
