vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- Define unhighlight_search function
local function unhighlight_search()
  vim.cmd('nohlsearch')
end

keymap.set('n', '<leader>u', unhighlight_search, {noremap = true, silent = true})
--
-- nvim tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer

-- tab
keymap.set("n", "<leader>1", ":tabnext 1<CR>") -- toggle file explorer
keymap.set("n", "<leader>2", ":tabnext 2<CR>") -- toggle file explorer
keymap.set("n", "<leader>3", ":tabnext 3<CR>") -- toggle file explorer
keymap.set("n", "<leader>4", ":tabnext 4<CR>") -- toggle file explorer
keymap.set("n", "<leader>5", ":tabnext 5<CR>") -- toggle file explorer

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

keymap.set("n", "sl", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show definition, references
keymap.set("n", "sb", "<cmd>Lspsaga show_buf_diagnostics<CR>", opts) -- show definition, references
keymap.set("n", "sw", "<cmd>Lspsaga show_workspace_diagnostics<CR>", opts) -- show definition, references
keymap.set("n", "sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show definition, references
keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer

keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- see available code actions
keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts) -- see outline on right hand side

keymap.set("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>", opts) -- show documentation for what is under cursor

keymap.set("n", "ci", "<cmd>Lspsaga incoming_calls<CR>", opts) -- show documentation for what is under cursor
keymap.set("n", "co", "<cmd>Lspsaga outgoing_calls<CR>", opts) -- show documentation for what is under cursor

keymap.set("n", "<leader>t", "<cmd>Lspsaga term_toggle<CR>", opts) -- show documentation for what is under cursor

-- Lua
keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
