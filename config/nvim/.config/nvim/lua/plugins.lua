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
        "alexghergh/nvim-tmux-navigation",
        config = function()
            local nvim_tmux_nav = require("nvim-tmux-navigation")
            nvim_tmux_nav.setup({
                keybindings = {
                    left = "<c-h>",
                    down = "<c-j>",
                    up = "<c-k>",
                    right = "<c-l>",
                    last_active = "<c-m>",
                    next = "<c-n>",
                },
            })
        end,
    },
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup({})
        end,
    },
    -- UI
    "kdheepak/lazygit.nvim",
    {
        "sainnhe/gruvbox-material",
        config = function()
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
        config = function()
            require("lualine").setup({
                options = {
                    globalstatus = true,
                    theme = "gruvbox-material",
                    component_separators = "",
                    section_separators = "",
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { "filename" },
                    lualine_x = { "" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup()
        end,
    },
    {
        "rcarriga/nvim-notify",
        config = function()
            vim.notify = require("notify")
            vim.o.termguicolors = true
            require("notify").setup({
                background_colour = "#000000",
            })
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup()
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup()
        end,
    },
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("diffview").setup()
        end,
    },
    "uga-rosa/ccc.nvim",
    {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({})
        end,
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
        "ggandor/leap.nvim",
        config = function()
            require("leap").opts.highlight_unlabeled_phase_one_targets = true
        end,
    },
    {
        "theprimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
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
            })
        end,
    },
    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup({})
        end,
    },

    -- editing
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup({})
        end,
    },
    "windwp/nvim-ts-autotag",
    "mbbill/undotree",
    "gpanders/editorconfig.nvim",
    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("spectre").setup({})
        end,
    },
    {
        "smjonas/inc-rename.nvim",
        config = function()
            require("inc_rename").setup({})
        end,
    },

    -- languages
    "NoahTheDuke/vim-just",
    "elkowar/yuck.vim",
    "simrat39/rust-tools.nvim",
    {
        "simrat39/rust-tools.nvim",
        config = function()
            require("rust-tools").setup({ tools = { inlay_hints = { only_current_line = true } } })
        end,
    },

    -- LSP
    "jose-elias-alvarez/null-ls.nvim",
    "rubixdev/mason-update-all",
    {
        "folke/trouble.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require("trouble").setup({})
        end,
    },

    -- LSP zero
    {
        "VonHeikemen/lsp-zero.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-cmdline",
            "amarakon/nvim-cmp-lua-latex-symbols",
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
        },
    },
})
