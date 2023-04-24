-- import lspsaga safely
local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
	return
end

saga.setup({
	-- keybinds for navigation in lspsaga window
	scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
  request_timeout = 2000,
	-- use enter to open file with definition preview
	definition = {
		edit = "<CR>",
	},
	ui = {
    title = true,
		colors = {
			normal_bg = "#022746",
		},
	},

  lightbulb = {
    enabled = true,
    enable_in_insert = true,
    sign = {
      enabled = true,
      priority = 10,
    },
    virtual_text = true,
  },

  diagnostic = {
    on_insert = false,
    on_insert_follow = false,
    insert_winblend = 0,
    show_code_action = true,
    show_source = true,
    jump_num_shortcut = true,
    max_width = 0.7,
    max_height = 0.6,
    max_show_width = 0.9,
    max_show_height = 0.6,
    text_hl_follow = true,
    border_follow = true,
    extend_relatedInformation = false,
    keys = {
      exec_action = 'o',
      quit = 'q',
      expand_or_jump = '<CR>',
      quit_in_show = { 'q', '<ESC>' },
    },
  },
})
