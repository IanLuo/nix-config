require("tokyonight").setup({
  transparent = true,
	-- use the night style
	style = "storm",
	dim_inactive = true,
	lualine_bold = true,
	-- disable italic for functions
	styles = {
		functions = {},
		sidebars = "transparent",
    floats = "transparent",
	},
	sidebars = { "qf", "vista_kind", "terminal", "packer" },
	-- Change the "hint" color to the "orange" color, and make the "error" color bright red
	on_colors = function(colors)
		colors.hint = colors.orange
		colors.error = "#f00000"
	end,
})
