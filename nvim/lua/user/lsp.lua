local M = {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        "onsails/lspkind.nvim",
        {
            "mrcjkb/rustaceanvim",
            version = "^4",
            lazy = false,
        },
        "folke/trouble.nvim",
    },
}

M.config = function()
    local lspconfig = require("lspconfig")
    local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local select_opts = { behavior = cmp.SelectBehavior.Select }
    cmp.setup({
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        window = { documentation = cmp.config.window.bordered() },
        mapping = cmp.mapping.preset.insert({
            ["<c-p>"] = cmp.config.disable,
            ["<c-f>"] = cmp.config.disable,
            ["<c-b>"] = cmp.config.disable,
            ["<c-j>"] = cmp.mapping.select_next_item(select_opts),
            ["<c-k>"] = cmp.mapping.select_prev_item(select_opts),
            ["<c-l>"] = cmp.mapping.confirm({ select = true }),
            ["<c-n>"] = cmp.mapping(cmp.mapping.scroll_docs(-4)),
            ["<c-m>"] = cmp.mapping(cmp.mapping.scroll_docs(4)),
            ["<Del>"] = cmp.mapping(function(fallback)
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        enabled = function()
            return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        end,
        formatting = {
            format = function(entry, vim_item)
                local kind = require("lspkind").cmp_format({
                    mode = "symbol_text",
                    maxwidth = 40,
                })(entry, vim_item)
                local strings = vim.split(kind.kind, "%s", { trimempty = true })
                kind.kind = " " .. (strings[1] or "") .. " "
                kind.menu = "    (" .. (strings[2] or "") .. ")"
                return kind
            end,
        },
        sources = {
            { name = "path" },
            { name = "nvim_lsp",               keyword_length = 1 },
            { name = "buffer",                 keyword_length = 3 },
            { name = "luasnip" },
            { name = "nvim_lsp_signature_help" },
        },
    })
    local cmp_cmdline_mappings = {
        ["<c-p>"] = cmp.config.disable,
        ["<c-j>"] = {
            c = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end,
        },
        ["<c-k>"] = {
            c = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end,
        },
    }
    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(cmp_cmdline_mappings),
        sources = { { name = "buffer" } },
    })
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(cmp_cmdline_mappings),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
    })
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

    require("mason").setup({})
    require("mason-lspconfig").setup({
        ensure_installed = {
            "bashls",
            "dockerls",
            "gopls",
            "marksman",
            "lua_ls",
            -- "nil_ls",
            -- "neocmake",
            "tsserver",
            "pyright",
        },
        handlers = {
            function(server_name)
                if server_name == "pyright" then
                    lspconfig.pyright.setup({
                        capabilities = lsp_capabilities,
                        on_new_config = function(config, root_dir)
                            local env = vim.trim(
                                vim.fn.system(
                                    'cd "' .. (root_dir or ".") .. '"; poetry env info --executable 2>/dev/null'
                                )
                            )
                            if string.len(env) > 0 then
                                config.settings.python.pythonPath = env
                            end
                        end,
                    })
                elseif server_name == "lua_ls" then
                    lspconfig["lua_ls"].setup({
                        settings = {
                            Lua = {
                                runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
                                diagnostics = { globals = { "vim" } },
                                workspace = {
                                    library = {
                                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                                    },
                                },
                            },
                        },
                    })
                else
                    lspconfig[server_name].setup({})
                end
            end,
        },
        automatic_installation = false,
    })
    require("trouble").setup()
    lspconfig.clangd.setup({ capabilities = lsp_capabilities })
    lspconfig.zls.setup({ capabilities = lsp_capabilities })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
end

return M
