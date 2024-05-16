local web_tools = { require("efmls-configs.linters.eslint"), require("efmls-configs.formatters.prettier") }

local languages = {
    sh = { require("efmls-configs.linters.shellcheck"), require("efmls-configs.formatters.shellharden") },
    bash = { require("efmls-configs.linters.shellcheck"), require("efmls-configs.formatters.shellharden") },
    zsh = { require("efmls-configs.linters.shellcheck"), require("efmls-configs.formatters.shellharden") },
    c = { require("efmls-configs.linters.cppcheck"), require("efmls-configs.formatters.clang_tidy") },
    cpp = { require("efmls-configs.linters.cppcheck"), require("efmls-configs.formatters.clang_tidy") },
    cmake = { require("efmls-configs.linters.cmake_lint"), require("efmls-configs.formatters.gersemi") },
    docker = { require("efmls-configs.linters.hadolint") },
    go = { require("efmls-configs.linters.golangci_lint"), require("efmls-configs.formatters.gofumpt") },
    html = { require("efmls-configs.formatters.prettier") },
    javascript = web_tools,
    javascriptreact = web_tools,
    typescript = web_tools,
    typescriptreact = web_tools,
    json = { require("efmls-configs.linters.jq"), require("efmls-configs.formatters.prettier") },
    yaml = { require("efmls-configs.linters.yamllint"), require("efmls-configs.formatters.prettier") },
    lua = { require("efmls-configs.linters.luacheck"), require("efmls-configs.formatters.stylua") },
    nix = { require("efmls-configs.linters.statix"), require("efmls-configs.formatters.alejandra") },
    python = { require("efmls-configs.linters.ruff"), require("efmls-configs.formatters.black") },
    rust = { require("efmls-configs.formatters.rustfmt") },
}
local efmls_config = {
    filetypes = vim.tbl_keys(languages),
    settings = {
        rootMarkers = { ".venv/", ".git/" },
        languages = languages,
    },
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
    },
}

require("lspconfig").efm.setup(vim.tbl_extend("force", efmls_config, {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
}))

local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
vim.api.nvim_create_autocmd("BufWritePost", {
    group = lsp_fmt_group,
    callback = function(ev)
        local efm = vim.lsp.get_active_clients({ name = "efm", bufnr = ev.buf })

        if vim.tbl_isempty(efm) then
            return
        end

        vim.lsp.buf.format({ name = "efm" })
    end,
})
