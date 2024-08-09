require("lspsaga").setup{}

local lspconfig = require('lspconfig')

lspconfig.nixd.setup{}

lspconfig.pyright.setup{}

lspconfig.ruby_ls.setup{
  cmd = { "bundle", "exec", "ruby-lsp" },
}

