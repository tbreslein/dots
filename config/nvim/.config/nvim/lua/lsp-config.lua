vim.opt.completeopt = { "menu", "menuone", "noselect" }

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

lspconfig.ansiblels.setup({ capabilites = capabilities })
lspconfig.astro.setup({ capabilites = capabilities })
lspconfig.fortls.setup({ capabilites = capabilities })
lspconfig.html.setup({ capabilites = capabilities })
lspconfig.pyright.setup({ capabilites = capabilities })
lspconfig.tsserver.setup({ capabilites = capabilities })
lspconfig.rust_analyzer.setup({ capabilites = capabilities })
lspconfig.yamlls.setup({ capabilites = capabilities })
lspconfig.zls.setup({ capabilites = capabilities })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		require("which-key").register({
			l = {
				name = "LSP actions",
				r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "rename" },
				f = { "<cmd>lua vim.lsp.buf.format({async = true})<cr>", "async format" },
				c = { "<cmd>lua vim.lsp.buf.code_action" },
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
	end,
})

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Tab>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline({ ":" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")
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
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})
