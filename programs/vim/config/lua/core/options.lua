local opt = vim.opt -- for concisensess

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs and andentation
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
-- opt.autoindent = true

-- line wrapping
opt.wrap = false

-- search
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

-- apperance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"


-- bakcspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")
