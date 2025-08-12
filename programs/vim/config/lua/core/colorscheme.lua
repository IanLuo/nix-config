-- require("plugins.tokyonight-config")

local status, _ = pcall(vim.cmd, "colorscheme tokyonight-moon")
if not status then
	print("colorscheme not found!")
	return
end
