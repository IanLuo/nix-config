local ok, illuminate = pcall(require, "illuminate")
if not ok then
	return
end

illuminate.configure({
	providers = { "lsp", "regex" },
	-- Telescope buffers: don't run LSP/regex reference highlighting in the picker
	filetypes_denylist = { "NvimTree", "alpha", "dirbuf", "dirvish", "fugitive", "TelescopePrompt", "TelescopeResults" },
})
