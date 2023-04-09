require("lspconfig").solargraph.setup({
	cmd = { "solargraph", "stdio" },
	filetypes = { "ruby" },
	settings = {
		solargraph = {
			diagnotics = true,
			completion = true,
			autoformat = true,
			folding = true,
			references = true,
			rename = true,
			symbols = true,
		},
	},
	init_options = {
		formatting = true,
	},
	flags = {
		debounce_text_changes = 150,
	},
})

local null_ls = require("null-ls")
local sources = { null_ls.builtins.diagnostics.rubocop }
null_ls.register({ sources = sources })
