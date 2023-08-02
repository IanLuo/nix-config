-- require("plugins.tokyonight-config")

local status, _ = pcall(vim.cmd, "colorscheme catppuccin")
if not status then
	print("colorschme not found!")
	return
end
