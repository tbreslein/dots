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
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup({})
        end,
    },
    -- UI
    -- {
    --   "sainnhe/gruvbox-material",
    --   config = function()
    --     vim.o.termguicolors = true
    --     vim.o.background = "dark"
    --     vim.g.gruvbox_material_background = "medium"
    --     vim.g.gruvbox_material_palette = "material"
    --     vim.g.gruvbox_material_enable_italic = 1
    --     vim.g.gruvbox_material_enable_bold = 1
    --     vim.g.gruvbox_material_transparent_background = 1
    --     vim.g.gruvbox_material_sign_column_background = "none"
    --     vim.cmd("colorscheme gruvbox-material")
    --   end,
    -- },
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                style = "storm",
                transparent = true,
            })
            vim.o.termguicolors = true
            vim.o.background = "dark"
            vim.cmd("colorscheme tokyonight")
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    globalstatus = true,
                    theme = "tokyonight",
                    component_separators = "",
                    section_separators = "",
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diagnostics" },
                    lualine_c = { "filename" },
                    lualine_x = { "" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },
    {
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup({
                window = {
                    width = 140,
                    options = {
                        number = true,
                        relativenumber = true,
                    },
                },
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
                    "help",
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
    "ggandor/leap.nvim",
    {
        "theprimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
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
