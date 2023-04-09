require("plugins.tokyonight-config")

local status, _ = pcall(vim.cmd, "colorscheme tokyonight")
if not status then
	print("colorschme not found!")
	return
end
