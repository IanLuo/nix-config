-- GitHub Copilot configuration
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

-- Custom keybindings for Copilot
vim.keymap.set('i', '<C-l>', 'copilot#Accept("")', {
  expr = true,
  replace_keycodes = false,
  silent = true
})

-- Alternative mappings
vim.keymap.set('i', '<C-j>', 'copilot#Next()', {
  expr = true,
  replace_keycodes = false,
  silent = true
})

vim.keymap.set('i', '<C-k>', 'copilot#Previous()', {
  expr = true,
  replace_keycodes = false,
  silent = true
})

-- Enable Copilot for specific filetypes
vim.g.copilot_filetypes = {
  ["*"] = false,
  ["javascript"] = true,
  ["typescript"] = true,
  ["typescriptreact"] = true,
  ["javascriptreact"] = true,
  ["lua"] = true,
  ["rust"] = true,
  ["c"] = true,
  ["cpp"] = true,
  ["go"] = true,
  ["python"] = true,
  ["ruby"] = true,
  ["java"] = true,
  ["php"] = true,
  ["swift"] = true,
  ["kotlin"] = true,
  ["dart"] = true,
  ["nix"] = true,
  ["bash"] = true,
  ["zsh"] = true,
  ["fish"] = true,
  ["yaml"] = true,
  ["json"] = true,
  ["toml"] = true,
  ["markdown"] = true,
  ["html"] = true,
  ["css"] = true,
  ["scss"] = true,
  ["sass"] = true,
}
