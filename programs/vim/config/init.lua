require("core.options")
require("core.keymaps")
require("core.colorscheme")
-- require("plugins.copilot")  -- TODO: Enable when unfree packages work
require("plugins.comment")

-- LuaSnip initialization moved to cmp-config to avoid loading order issues

require("plugins.cmp-config")
require("plugins.nvim-tree")
require("plugins.telescope")
-- require("plugins.nvim-cmp")
require("plugins.autopairs")
require("plugins.treesitter")
require("plugins.legendary-config")
require("plugins.indent-blankline-config")
require("plugins.lsp")

require("neogit").setup{}

require("gitsigns").setup{}

-- Cursor visibility improvements for transparent backgrounds
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Ensure cursor is highly visible with bright colors
    vim.api.nvim_set_hl(0, "Cursor", { bg = "#ff9e64", fg = "#1a1b26" })  -- Orange background, dark foreground
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#292e42" })  -- Slightly visible line highlight
    vim.api.nvim_set_hl(0, "Visual", { bg = "#364a82" })  -- Blue selection
  end,
})

-- Apply cursor highlighting immediately
vim.api.nvim_set_hl(0, "Cursor", { bg = "#ff9e64", fg = "#1a1b26" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#292e42" })
vim.api.nvim_set_hl(0, "Visual", { bg = "#364a82" })
