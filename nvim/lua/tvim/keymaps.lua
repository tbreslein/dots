local function toggle_todo(x)
    local function replaceAt(str, at, with)
        return string.sub(str, 1, at - 1) .. with .. (string.sub(str, at + 1, string.len(str)))
    end

    local curr_line = vim.api.nvim_get_current_line()
    local _, snd_bckt = string.find(curr_line, "%s*%- %[.%]")
    if snd_bckt == nil then
        return
    end
    local status_idx = snd_bckt - 1
    local status_symbol = string.sub(curr_line, status_idx, status_idx)
    if status_symbol == x then
        vim.api.nvim_set_current_line(replaceAt(curr_line, status_idx, " "))
    else
        vim.api.nvim_set_current_line(replaceAt(curr_line, status_idx, x))
    end
    return
end

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
        ["<m-u>"] = {
            function()
                require("harpoon"):list():select(1)
            end,
            "which_key_ignore",
        },
        ["<m-i>"] = {
            function()
                require("harpoon"):list():select(2)
            end,
            "which_key_ignore",
        },
        ["<m-o>"] = {
            function()
                require("harpoon"):list():select(3)
            end,
            "which_key_ignore",
        },
        ["<m-p>"] = {
            function()
                require("harpoon"):list():select(4)
            end,
            "which_key_ignore",
        },
        ["<leader>"] = {
            w = { "<cmd>w<cr>", "which_key_ignore", silent = false },
            r = { '"hy:%s/<c-r>h//g<left><left>', "replace", silent = false },
            y = { '"+y', "which_key_ignore", mode = { "n", "v", "x" } },
            p = { '"+p', "which_key_ignore", mode = { "n", "v", "x" } },
            T = { "<cmd>TroubleToggle<cr>", "trouble" },
        },
        ["<leader>n"] = {
            name = "notes",
            n = {
                function()
                    if string.sub(vim.uv.cwd(), 1, string.len(vim.g.my_obsidian_vault)) == vim.g.my_obsidian_vault then
                        vim.cmd("ObsidianQuickSwitch")
                    else
                        vim.cmd(
                            "silent !tmux new-window -c " .. vim.g.my_obsidian_vault .. " nvim +ObsidianQuickSwitch"
                        )
                    end
                end,
                "fzf in notes",
            },
            d = {
                function()
                    if string.sub(vim.uv.cwd(), 1, string.len(vim.g.my_obsidian_vault)) == vim.g.my_obsidian_vault then
                        vim.cmd("e " .. vim.g.my_obsidian_vault .. "/todos.md")
                    else
                        vim.cmd("silent !tmux new-window -c " .. vim.g.my_obsidian_vault .. " nvim todos.md")
                    end
                end,
                "open todos",
            },
        },
        ["<leader>t"] = {
            name = "todos",
            t = "toggle todo checkbox DONE",
            d = {
                function()
                    toggle_todo(">")
                end,
                "toggle todo checkbox DELAYED",
            },
            c = {
                function()
                    toggle_todo("~")
                end,
                "toggle todo checkbox CANCELED",
            },
            o = { "o- [ ] ", "new todo below" },
            O = { "O- [ ] ", "new todo above" },
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
        ["gl"] = { vim.diagnostic.open_float, "diagnostic float" },
        ["gj"] = { vim.diagnostic.goto_next, "next diagnostic" },
        ["gk"] = { vim.diagnostic.goto_prev, "prev diagnostic" },
        ["<leader>d"] = {
            name = "debug",
            t = { "<cmd>DapToggleBreakpoint<cr>", "toggle breakpoint" },
            x = { "<cmd>DapTerminate<cr>", "terminate" },
            o = { "<cmd>DapStepOver<cr>", "step over" },
        },
        s = {
            function()
                require("flash").jump()
            end,
            "which_key_ignore",
            mode = { "n", "x", "o" },
        },
    })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        desc = "Lsp actions",
        callback = function(ev)
            wk.register({
                K = { vim.lsp.buf.hover, "lsp hover" },
                g = {
                    name = "goto",
                    d = { vim.lsp.buf.definition, "definition" },
                    D = { vim.lsp.buf.declaration, "declaration" },
                    i = { vim.lsp.buf.implementation, "implementation" },
                    o = { vim.lsp.buf.type_definition, "type def" },
                    r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
                    s = { vim.lsp.buf.signature_help, "sig help" },
                },
                ["<leader>R"] = { vim.lsp.buf.rename, "lsp rename" },
                ["<leader>A"] = { vim.lsp.buf.code_action, "code action" },
            }, { buffer = ev.buf })
        end,
    })
end

return M
