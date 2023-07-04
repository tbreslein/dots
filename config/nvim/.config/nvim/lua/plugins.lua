local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"mrjones2014/legendary.nvim",
	{
		"aserowy/tmux.nvim",
		opts = {
			copy_sync = { enable = false },
		},
	},
	{
		"folke/which-key.nvim",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		config = true,
	},
	-- UI
	{
		"sainnhe/gruvbox-material",
		init = function()
			vim.o.termguicolors = true
			vim.o.background = "dark"
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_foreground = "material"
			vim.g.gruvbox_material_enable_italic = 1
			vim.g.gruvbox_material_enable_bold = 1
			vim.g.gruvbox_material_transparent_background = 1
			vim.g.gruvbox_material_sign_column_background = "none"
			vim.g.gruvbox_material_ui_contrast = "high"
			vim.g.gruvbox_material_statusline_style = "mix"
			vim.cmd("colorscheme gruvbox-material")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons" },
		opts = {
			options = {
				globalstatus = true,
				theme = "gruvbox-material",
				component_separators = "",
				section_separators = "",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = { "diagnostics" },
				lualine_x = { "" },
				lualine_y = { { "filename", path = 3 } },
				lualine_z = { "progress" },
			},
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = true,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
	},
	{
		"j-hui/fidget.nvim",
		config = true,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = { "nvim-treesitter/nvim-treesitter-context" },
		build = function()
			vim.cmd("TSUpdate")
		end,
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"vimdoc",
					"javascript",
					"typescript",
					"tsx",
					"css",
					"html",
					"astro",
					"json",
					"toml",
					"yaml",
					"bash",
					"gitignore",
					"haskell",
					"python",
					"c",
					"cpp",
					"cmake",
					"make",
					"markdown",
					"lua",
					"rust",
					"zig",
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				autotag = {
					enable = true,
				},
			})
		end,
	},

	-- movement
	{
		"folke/flash.nvim",
		opts = {},
	},
	{
		"theprimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			file_ignore_patterns = {
				"vendor/*",
				"%.lock",
				"__pycache__/*",
				"%.sqlite3",
				"%.ipynb",
				"node_modules/*",
				"%.jpg",
				"%.jpeg",
				"%.png",
				"%.svg",
				"%.otf",
				"%.ttf",
				".git/",
				"%.webp",
				".dart_tool/",
				".github/",
				".gradle/",
				".idea/",
				".settings/",
				".vscode/",
				"__pycache__/",
				"build/",
				"env/",
				"gradle/",
				"node_modules/",
				"target/",
				"%.pdb",
				"%.dll",
				"%.class",
				"%.exe",
				"%.cache",
				"%.ico",
				"%.pdf",
				"%.dylib",
				"%.jar",
				"%.docx",
				"%.met",
				"smalljre_*/*",
				".vale/",
			},
		},
	},
	{
		"echasnovski/mini.files",
		config = true,
	},

	-- editing
	{
		"altermo/ultimate-autopair.nvim",
		config = true,
	},
	{
		"numToStr/Comment.nvim",
		config = true,
	},
	"windwp/nvim-ts-autotag",
	"mbbill/undotree",
	"gpanders/editorconfig.nvim",
	{
		"AckslD/muren.nvim",
		config = true,
	},

	-- languages
	"NoahTheDuke/vim-just",
	"elkowar/yuck.vim",
	{
		"MunifTanjim/rust-tools.nvim",
		branch = "patched",
	},

	-- DAP
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
		config = true,
	},
	{
		"mfussenegger/nvim-dap-python",
		dependencies = { "mfussenegger/nvim-dap" },
	},
	"David-Kunz/jester",

	-- LSP
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
	},

	"jose-elias-alvarez/null-ls.nvim",
})
