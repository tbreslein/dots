local M = {
    "folke/trouble.nvim",
    "mhartington/formatter.nvim",
    "mfussenegger/nvim-lint",
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            { "mrcjkb/rustaceanvim", ft = { "rust" } },
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind.nvim",
        },
    },
}

function M.config()
    require("trouble").setup()
    local formutil = require("formatter.util")
    require("formatter").setup({
        filetype = {
            c = { require("formatter.filetypes.c").clangformat },
            cpp = { require("formatter.filetypes.cpp").clangformat },
            cmake = { require("formatter.filetypes.cmake").cmakeformat },
            go = { require("formatter.filetypes.go").gofmt },
            haskell = { require("formatter.filetypes.haskell").stylish_haskell },
            ocaml = { require("formatter.filetypes.ocaml").ocamlformat },
            lua = { require("formatter.filetypes.lua").stylua },
            python = { require("formatter.filetypes.python").black },
            rust = { require("formatter.filetypes.rust").rustfmt },
            zig = { require("formatter.filetypes.zig").zigfmt },
            css = { require("formatter.filetypes.css").prettier },
            html = { require("formatter.filetypes.html").prettier },
            javascript = { require("formatter.filetypes.javascript").prettier },
            javascriptreact = { require("formatter.filetypes.javascriptreact").prettier },
            typescript = { require("formatter.filetypes.typescript").prettier },
            typescriptreact = { require("formatter.filetypes.typescriptreact").prettier },
            svelte = { require("formatter.filetypes.svelte").prettier },
            json = { require("formatter.filetypes.json").jq },
            toml = { require("formatter.filetypes.toml").taplo },
            yaml = { require("formatter.filetypes.yaml").prettier },
            markdown = { require("formatter.filetypes.markdown").prettier },
            nix = { require("formatter.filetypes.nix").nixfmt },
            sh = { require("formatter.filetypes.sh").shfmt },
            zsh = { require("formatter.filetypes.zsh").beautysh },
            ["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
        },
    })

    vim.api.nvim_create_augroup("__formatter__", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = "__formatter__",
        command = ":FormatWrite",
    })

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
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
            require("lint").try_lint()
        end,
    })

    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end

    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
    })

    vim.diagnostic.config({
        virtual_text = false,
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    })

    local lspconfig = require("lspconfig")
    local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
    -- NOTE: rust-analyzer is setup by rustaceanvim!
    -- lspconfig.rust_analyzer.setup({
    --     capabilities = lsp_capabilities,
    --     settings = { ["rust-analyzer"] = { files = { excludeDirs = { ".direnv" } } } },
    -- })
    lspconfig.clangd.setup({ capabilities = lsp_capabilities })
    lspconfig.neocmake.setup({ capabilities = lsp_capabilities })
    lspconfig.gopls.setup({ capabilities = lsp_capabilities })
    lspconfig.zls.setup({ capabilities = lsp_capabilities })
    lspconfig.pyright.setup({
        capabilities = lsp_capabilities,
        on_new_config = function(config, root_dir)
            local env =
                vim.trim(vim.fn.system('cd "' .. (root_dir or ".") .. '"; poetry env info --executable 2>/dev/null'))
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
    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
    require("lspconfig.ui.windows").default_options.border = "rounded"

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

    require("which-key").register({
        ["<leader>T"] = { "<cmd>TroubleToggle<cr>", "trouble" },
        ["gl"] = { vim.diagnostic.open_float, "diagnostic float" },
        ["gj"] = { vim.diagnostic.goto_next, "next diagnostic" },
        ["gk"] = { vim.diagnostic.goto_prev, "prev diagnostic" },
        ["<leader>d"] = {
            name = "debug",
            t = { "<cmd>DapToggleBreakpoint<cr>", "toggle breakpoint" },
            x = { "<cmd>DapTerminate<cr>", "terminate" },
            o = { "<cmd>DapStepOver<cr>", "step over" },
        },
    })
end

return M
