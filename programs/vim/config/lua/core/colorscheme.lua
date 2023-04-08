local status, _ = pcall(vim.cmd, "colorscheme nightfly")
if not status then
	print("colorschme not found!")
	return
end
