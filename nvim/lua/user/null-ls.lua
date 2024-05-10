local M = {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "nvimtools/none-ls.nvim",
    },
}

M.config = function()
    require("mason-null-ls").setup({
        ensure_installed = {
            -- shell
            "shellcheck",
            "shellharden", -- also formats

            -- c/cpp/cmake
            "cmakelint",
            "clang-format",

            -- go
            "golangci-lint",
            "gofumpt",

            -- lua
            "luacheck",
            "stylua",

            -- python
            "black",

            -- nix
            "statix",

            -- web
            "eslint_d",
            "prettier",

            -- configs
            "jq",
            "hadolint",
            "yamllint",
        },
        automatic_installation = { exclude = { "rust_analyzer" } },
        handlers = {},
    })

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    local null_ls = require("null-ls")
    null_ls.setup({
        sources = { -- Anything not supported by mason.
            -- shell
            null_ls.builtins.diagnostics.zsh,

            -- c/cpp/cmake
            null_ls.builtins.diagnostics.cppcheck,
            null_ls.builtins.formatting.cmake_format,

            -- nix
            null_ls.builtins.code_actions.statix,
            null_ls.builtins.diagnostics.statix,
            null_ls.builtins.formatting.alejandra,

            -- python
            null_ls.builtins.formatting.black.with({
                prefer_local = ".venv/bin",
            }),

            -- web
            null_ls.builtins.formatting.prettier.with({
                extra_filetypes = { "astro", "markdown", "svelte", "toml" },
                prefer_local = "node_modules/.bin",
            }),

            -- rustfmt
            -- configs
            null_ls.builtins.formatting.just,
        },
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                        -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
                        vim.lsp.buf.format({ async = false })
                    end,
                })
            end
        end,
    })
end

return M
