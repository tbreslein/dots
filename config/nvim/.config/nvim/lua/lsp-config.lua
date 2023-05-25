require("mason-update-all").setup({})

local lsp = require("lsp-zero").preset({
    name = "minimal",
    set_lsp_keymaps = { preserve_mappings = false },
    manage_nvim_cmp = false,
    suggest_lsp_servers = false,
})

lsp.on_attach(function(_, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    require("which-key").register({
        l = {
            name = "LSP actions",
            r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "rename" },
            f = { "<cmd>lua vim.lsp.buf.format({async = true})<cr>", "async format" },
        },
    }, {
        prefix = "<leader>",
    })
    require("which-key").register({
        g = {
            name = "go to (LSP)",
            d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "definition" },
            D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "declaration" },
            i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "implementation" },
            t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "type def" },
            r = { "<cmd>Telescope lsp_references<cr>", "lsp references" },
            s = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "signature help" },
            l = { "<cmd>lua vim.diagnostic.open_float()<cr>", "diagnostic float" },
            n = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "next diagnostic" },
            p = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "prev diagnostic" },
        },
    })
end)

lsp.nvim_workspace()
local rust_lsp = lsp.build_options("rust_analyzer", {})

-- servers that are installed globally and only need to be setup
lsp.setup_servers({ "ccls", "pylsp", "zls" })

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")
-- local nc = null_ls.builtins.code_actions
local nd = null_ls.builtins.diagnostics
local nf = null_ls.builtins.formatting
null_ls.setup({
    sources = {
        -- c/c++
        nd.cppcheck,
        nf.clang_format,
        -- js/ts
        nd.eslint,
        nf.prettierd.with({
            extra_filetypes = { "svelte", "toml" },
        }),
        nd.tsc.with({ prefer_local = "node_modules/.bin" }),
        -- lua
        nf.stylua,
        nd.luacheck.with({ extra_args = { "--globals", "vim" } }),
        -- shell, docker, config files, etc
        nd.shellcheck,
        nd.ansiblelint,
        nd.hadolint,
        -- nf.shellharden,
        -- python
        nd.ruff,
        nf.black,
        -- rust
        nf.rustfmt,
        -- zig
        nf.zigfmt,
    },
    -- on_attach = null_opts.on_attach,
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                    -- vim.lsp.buf.formatting_sync()
                end,
            })
        end
    end,
})

lsp.setup()

vim.opt.completeopt = { "menu", "menuone", "noselect" }

local cmp = require("cmp")
local cmp_mappings = lsp.defaults.cmp_mappings()
cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil
cmp_mappings["<CR>"] = nil
local cmp_sources = lsp.defaults.cmp_sources()
table.insert(cmp_sources, { name = "lua-latex-symbols", option = { cache = true } })

local icons = {
    Class = "",
    Constant = "",
    Constructor = "",
    Field = "",
    Function = "",
    Keyword = "",
    Method = "",
    Module = "",
    Snippet = "󰅴",
    Text = "",
    Variable = "󰭷",

    nvim_lsp = "LSP",
    buffer = "Buf",
    luasnip = "Snp",
    latex_symbols = "TeX",
}

local cmp_config = lsp.defaults.cmp_config({
    window = {
        completion = cmp.config.window.bordered(),
    },
    mappings = cmp_mappings,
    sources = cmp_sources,
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local function trim(text, max)
                if text and text:len() > max then
                    text = text:sub(1, max) .. "..."
                end
                return text
            end

            vim_item.kind = icons[vim_item.kind] or vim_item.kind

            local source = entry.source.name
            if source == "lua-latex-symbols" then
                source = "latex_symbols"
            end

            vim_item.menu = " [" .. (icons[source] or source) .. "]"

            if source == "luasnip" or source == "nvim_lsp" then
                vim_item.dup = 0
            end

            vim_item.abbr = trim(vim_item.abbr, 70)
            return vim_item
        end,
    },
})
cmp.setup(cmp_config)

-- lsp.setup_nvim_cmp({
-- 	mapping = cmp_mappings,
-- 	sources = cmp_sources,
-- })

-- restore some diagnostics settings
vim.diagnostic.config({
    virtual_text = true,
})

require("rust-tools").setup({
    server = rust_lsp,
    tools = { inlay_hints = { only_current_line = true } },
})

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        {
            name = "cmdline",
            option = {
                ignore_cmds = { "Man", "!" },
            },
        },
    }),
})
