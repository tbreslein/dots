return {
    { "folke/trouble.nvim", opts = {} },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                c = { "clang_format" },
                cpp = { "clang_format" },
                cmake = { "cmake_format" },
                go = { "gofumpt" },
                rust = { "rustfmt" },
                zig = { "zigfmt" },
                python = { "black" },
                lua = { "stylua" },
                markdown = { "prettier" },
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                yaml = { "prettier" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                zsh = { "shfmt" },
                nix = { "nixfmt" },
            },
            format_after_save = { lsp_fallback = false },
            notify_on_error = false,
        },
    },
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                c = { "cppcheck" },
                cpp = { "cppcheck" },
                -- cmake = { "cmakelint" },
                go = { "golangcilint" },
                python = { "ruff" },
                javascript = { "eslint" },
                javascriptreact = { "eslint" },
                typescript = { "eslint" },
                typescriptreact = { "eslint" },
                svelte = { "eslint" },
                sh = { "shellcheck" },
                bash = { "shellcheck" },
                nix = { "nix", "statix" },
                dockerfile = { "hadolint" },
                yaml = { "yamllint" },
            }
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind.nvim",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
            lspconfig.clangd.setup({ capabilities = lsp_capabilities })
            lspconfig.neocmake.setup({ capabilities = lsp_capabilities })
            lspconfig.gopls.setup({ capabilities = lsp_capabilities })
            lspconfig.rust_analyzer.setup({
                capabilities = lsp_capabilities,
                settings = { ["rust-analyzer"] = { files = { excludeDirs = { ".direnv" } } } },
            })
            lspconfig.zls.setup({ capabilities = lsp_capabilities })
            lspconfig.pyright.setup({
                capabilities = lsp_capabilities,
                on_new_config = function(config, root_dir)
                    local env = vim.trim(
                        vim.fn.system('cd "' .. (root_dir or ".") .. '"; poetry env info --executable 2>/dev/null')
                    )
                    if string.len(env) > 0 then
                        config.settings.python.pythonPath = env
                    end
                end,
            })
            lspconfig.marksman.setup({ capabilities = lsp_capabilities })
            lspconfig.nil_ls.setup({ capabilities = lsp_capabilities })
            lspconfig.astro.setup({ capabilities = lsp_capabilities })
            lspconfig.html.setup({ capabilities = lsp_capabilities })
            lspconfig.svelte.setup({ capabilities = lsp_capabilities })
            lspconfig.tsserver.setup({ capabilities = lsp_capabilities })

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
                    { name = "nvim_lsp", keyword_length = 1 },
                    { name = "buffer", keyword_length = 3 },
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
        end,
    },
}
