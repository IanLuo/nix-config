vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
--
-- nvim tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

-- telescope git commands (not on youtube nvim video)
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list available help tags

-- restart lsp server (not on youtube nvim video)
keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary


	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
	keymap.set("n", "gr", "<cmd>Lspsaga rename<CR>", opts) -- show definition, references
	keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	keymap.set("n", "gp", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
	keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts) -- show definition, references
	keymap.set("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>", opts) -- show definition, references
	keymap.set("n", "gt", "<cmd>Lspsaga goto_type_definition<CR>", opts) -- show definition, references

	keymap.set("n", "sl", "<cmd>Lspsaga Lspsaga show_line_diagnostics<CR>", opts) -- show definition, references
	keymap.set("n", "sb", "<cmd>Lspsaga Lspsaga show_buf_diagnostics<CR>", opts) -- show definition, references
	keymap.set("n", "sw", "<cmd>Lspsaga Lspsaga show_workspace_diagnostics<CR>", opts) -- show definition, references
	keymap.set("n", "sc", "<cmd>Lspsaga Lspsaga show_cursor_diagnostics<CR>", opts) -- show definition, references
	keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer

	keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- see available code actions
	keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts) -- see outline on right hand side

	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>", opts) -- show documentation for what is under cursor

	keymap.set("n", "ci", "<cmd>Lspsaga incoming_calls<CR>", opts) -- show documentation for what is under cursor
	keymap.set("n", "co", "<cmd>Lspsaga outgoing_calls<CR>", opts) -- show documentation for what is under cursor

	keymap.set("n", "<leader>t", "<cmd>Lspsaga term_toggle<CR>", opts) -- show documentation for what is under cursor

