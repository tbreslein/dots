vim.g.mapleader = " "

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local builtin = require("telescope.builtin")
local hop = require("hop")
local directions = require("hop.hint").HintDirection
local dap = require("dap")
local dapui = require("dapui")
local dappython = require("dap-python")

require("legendary").setup({
	keymaps = {
		{ ">", ">gv", description = "indent right", mode = { "v" } },
		{ "<", "<gv", description = "indent left", mode = { "v" } },
		{ "Y", "yg$", description = "yank to end of line", mode = { "n" } },
		{ "J", ":m '>+1<cr>gv=gv'", description = "move visual block down", mode = { "v" } },
		{ "K", ":m '<-2<cr>gv=gv'", description = "move visual block up", mode = { "v" } },
		{ "J", "mzJ`z", description = "join lines without moving cursor", mode = { "n" } },
		{ "<c-d>", "<c-d>zz", description = "scroll half page down and recenter", mode = { "n" } },
		{ "<c-u>", "<c-u>zz", description = "scroll half page up and recenter", mode = { "n" } },
		{ "n", "nzzzv", description = "jump to next match and recenter", mode = { "n" } },
		{ "N", "Nzzzv", description = "jump to prev match and recenter", mode = { "n" } },
		{ "P", [["_dP]], description = "paste without losing register", mode = { "v" } },
		{ "Q", "<nop>", description = "remove Q keybind", mode = { "n" } },
		{ "<c-b>", "<cmd>cnext<cr>zz", description = "next in quickfix list", mode = { "n" } },
		{ "<c-f>", "<cmd>cprev<cr>zz", description = "prev in quickfix list", mode = { "n" } },
		{ "<leader>j", "<cmd>lprev<cr>zz", description = "prev in loclist", mode = { "n" } },
		{ "<leader>k", "<cmd>lnext<cr>zz", description = "next in loclist", mode = { "n" } },
		{
			"f",
			function()
				hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
			end,
			decription = "hop forward in line",
			mode = { "n" },
		},
		{
			"F",
			function()
				hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
			end,
			decription = "hop backward in line",
			mode = { "n" },
		},
		{
			"F",
			function()
				hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
			end,
		},
		{
			"s",
			function()
				hop.hint_char1({ direction = directions.AFTER_CURSOR })
			end,
			decription = "hop forward",
			mode = { "n" },
		},
		{
			"S",
			function()
				hop.hint_char1({ direction = directions.BEFORE_CURSOR })
			end,
			decription = "hop backward",
			mode = { "n" },
		},
		{
			"<leader>y",
			'"+y',
			description = "yank into system clipboard",
			mode = { "n", "v" },
		},
		{ "<leader>Y", '"+Y', description = "yank to end of line into system clipboard", mode = { "n" } },
		{
			"<leader>S",
			":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
			description = "search and replace word under cursor",
			mode = { "n" },
		},
		{
			"<leader>S",
			":s/\\(\\)<Left><Left>",
			description = "search and replace word under cursor",
			mode = { "v" },
		},
		{ "jk", "<c-\\><c-n>", description = "leave insert mode in embedded terminal", mode = { "t" } },
		{ "<leader>a", mark.add_file, description = "add harpoon mark", mode = { "n" } },
		{ "<c-e>", ui.toggle_quick_menu, description = "toggle harpoon quick menu", mode = { "n" } },
		{
			"<m-u>",
			function()
				ui.nav_file(1)
			end,
			description = "nav to harpoon mark 1",
			mode = { "n" },
		},
		{
			"<m-i>",
			function()
				ui.nav_file(2)
			end,
			description = "nav to harpoon mark 2",
			mode = { "n" },
		},
		{
			"<m-o>",
			function()
				ui.nav_file(3)
			end,
			description = "nav to harpoon mark 3",
			mode = { "n" },
		},
		{
			"<m-p>",
			function()
				ui.nav_file(4)
			end,
			description = "nav to harpoon mark 4",
			mode = { "n" },
		},
		{
			"<m-y>",
			function()
				ui.nav_file(5)
			end,
			description = "nav to harpoon mark 5",
			mode = { "n" },
		},
		{ "<leader>u", "<cmd>UndotreeToggle<cr>", description = "toggle undo tree", mode = { "n" } },
	},
	which_key = { auto_register = true },
})

require("which-key").register({
	p = {
		name = "project",
		f = { builtin.git_files, "find files respecting gitignore" },
		F = { "<cmd>Telescope find_files hidden=true<cr>", "find files" },
		s = { builtin.live_grep, "live grep" },
		p = { require("oil").open, "project view" },
	},
	t = {
		name = "terminal",
		h = { "<cmd>ToggleTerm direction=horizontal<cr>", "toggleterm horizontal" },
		j = { "<cmd>ToggleTerm direction=horizontal<cr>", "toggleterm vertical" },
		t = { "<cmd>ToggleTerm direction=float<cr>", "toggleterm float" },
	},
	c = { "<cmd>lua vim.lsp.buf.clear_references()<cr>", "clear highlight references" },
}, {
	prefix = "<leader>",
})
