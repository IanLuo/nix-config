local ok, illuminate = pcall(require, "illuminate")
if not ok then
	return
end

illuminate.configure({
	providers = { "lsp", "regex" },
	filetypes_denylist = { "NvimTree", "alpha", "dirbuf", "dirvish", "fugitive" },
})
