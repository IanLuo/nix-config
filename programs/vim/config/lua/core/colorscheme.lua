-- Load the active theme's setup (must run before the colorscheme command —
-- theme options like transparency only apply at setup time), then apply it.
require("plugins.nightfox")

local status, _ = pcall(vim.cmd, "colorscheme nightfox")
if not status then
	print("colorscheme not found!")
	return
end
