vim.g.mapleader = " "

local km = vim.keymap.set
local opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, silent = true, expr = true }
local loud_opts = { noremap = true, silent = false }

-- ### CORE
km("n", "Q", "<nop>", opts)
km("n", "<esc>", "<cmd>noh<cr>", opts)
km("t", "jk", "<C-\\><C-n>", opts)

km("n", "n", "nzz", opts)
km("n", "N", "Nzz", opts)
km("n", "*", "*zz", opts)
km("n", "#", "#zz", opts)
km("n", "g*", "g*zz", opts)
km("n", "g#", "g#zz", opts)
km({ "n", "v" }, "<c-d>", "<c-d>zz", opts)
km({ "n", "v" }, "<c-u>", "<c-u>zz", opts)

km("n", "<leader>cj", "<cmd>cnext<cr>zz", opts)
km("n", "<leader>ck", "<cmd>cprev<cr>zz", opts)
km("n", "<leader>ct", function()
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
end, opts)

km("v", "<", "<gv", opts)
km("v", ">", ">gv", opts)
km("v", "K", ":m '<-2<cr>gv=gv", opts)
km("v", "J", ":m '>+1<cr>gv=gv", opts)
km("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, silent = true, expr = true })
km("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, silent = true, expr = true })

km("v", "P", [["_dP]], opts)
km({ "n", "v", "x" }, "x", [["_x]], opts)
km({ "n", "v", "x" }, "<leader>y", [["+y]], opts)
km({ "n", "v", "x" }, "<leader>p", [["+p]], opts)
km("n", "Y", "yg$", opts)
km("n", "J", "mzJ`z", opts)

km("n", "<leader>w", "<cmd>w<cr>", loud_opts)
km("n", "<leader>r", [["hy:%s/<c-r>h//g<left><left>]], loud_opts)

-- ### NAVIGATION
local harp = require("harpoon")
km("n", "<m-6>", function()
    harp:list():select(1)
end, opts)
km("n", "<m-7>", function()
    harp:list():select(2)
end, opts)
km("n", "<m-8>", function()
    harp:list():select(3)
end, opts)
km("n", "<m-9>", function()
    harp:list():select(4)
end, opts)
km("n", "<m-0>", function()
    harp:list():select(5)
end, opts)
km("n", "<leader>a", function()
    harp:list():add()
end, opts)
km("n", "<leader>e", function()
    harp.ui:toggle_quick_menu(harp:list())
end, opts)
km({ "n", "x", "o" }, "s", function()
    require("flash").jump()
end, opts)

local builtin = require("telescope.builtin")
km("n", "<leader>ff", function()
    vim.fn.system("git rev-parse --is-inside-work-tree")
    if vim.v.shell_error == 0 then
        builtin.git_files(require("telescope.themes").get_dropdown({}))
    else
        builtin.find_files(require("telescope.themes").get_dropdown({}))
    end
end, opts)
km("n", "<leader>fg", function()
    builtin.git_files(require("telescope.themes").get_dropdown({}))
end, opts)
km("n", "<leader>fs", function()
    builtin.live_grep(require("telescope.themes").get_dropdown({}))
end, opts)
km("n", "<leader>fo", require("oil").toggle_float, opts)
km("n", "<leader>fe", function()
    if string.sub(vim.uv.cwd(), 1, string.len(vim.g.my_dotfiles)) == vim.g.my_dotfiles then
        require("telescope.builtin").find_files()
    else
        vim.cmd("silent !tmux new-window -c " .. vim.g.my_dotfiles .. [[ nvim "+Telescope git_files"]])
    end
end, opts)
km("n", "<leader>u", "<cmd>Telescope undo<cr>", opts)

-- ### GIT
km("n", "<leader>gg", "<cmd>Git<cr>", opts)
km("n", "<leader>g<space>", "<cmd>Git<space>", loud_opts)
km("n", "<leader>gG", "<cmd>Telescope git_status<cr>", opts)
km("n", "<leader>gp", "<cmd>Git pull<cr>", opts)
km("n", "<leader>gP<space>", "<cmd>Git push<space>", loud_opts)
km("n", "<leader>gPP", "<cmd>Git push<cr>", opts)
km("n", "<leader>gPF", "<cmd>Git push --force-with-lease<cr>", opts)
km("n", "<leader>gPU", "<cmd>Git push --set-upstream origin<cr>", opts)
km("n", "<leader>gl", "<cmd>Git log<cr>", opts)
km("n", "<leader>gs", "<cmd>Telescope git_branches<cr>", opts)
km("n", "<leader>gB<space>", "<cmd>Git checkout -b<space>", loud_opts)
km("n", "<leader>gm<space>", "<cmd>Git merge<space>", loud_opts)
km("n", "<leader>gmd", "<cmd>Gvdiffsplit!<cr>", opts)
km("n", "<leader>gmh", "<cmd>diffget //2<cr>", opts)
km("n", "<leader>gml", "<cmd>diffget //3<cr>", opts)

-- ### LSP
km("n", "<leader>T", "<cmd>TroubleToggle<cr>", opts)

-- ### DAP
km("n", "<leader>dt", "<cmd>DapToggleBreakpoint<cr>", opts)
km("n", "<leader>dx", "<cmd>DapTerminate<cr>", opts)
km("n", "<leader>do", "<cmd>DapStepOver<cr>", opts)
