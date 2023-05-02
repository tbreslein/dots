require("mason-update-all").setup({})

local lsp = require("lsp-zero").preset({
	name = "minimal",
	set_lsp_keymaps = { preserve_mappings = false },
	manage_nvim_cmp = false,
	suggest_lsp_servers = false,
})

lsp.nvim_workspace()
local rust_lsp = lsp.build_options("rust_analyzer", {})

-- servers that are installed globally and only need to be setup
lsp.setup_servers({ "ccls", "pylsp", "zls", force = true })

-- local null_opts = lsp.build_options("null-ls", {
-- 	on_attach = function(client, bufnr)
-- 		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- 		vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })
-- 		if client.supports_method("textDocument/formatting") then
-- 			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
-- 			vim.api.nvim_create_autocmd("BufWritePre", {
-- 				group = augroup,
-- 				buffer = bufnr,
-- 				callback = function()
-- 					return vim.lsp.buf.format({ bufnr = bufnr })
-- 				end,
-- 			})
-- 		end
-- 	end,
-- })

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
		-- python
		nd.ruff,
		nf.black,
		-- rust
		nf.rustfmt,
		-- zig
		nf.zigfmt,
	},
	-- on_attach = null_opts.on_attach,
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
