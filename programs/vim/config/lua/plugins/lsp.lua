require("lspsaga").setup{}

local lspconfig = require('lspconfig')

-- Setup completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.nixd.setup{
  capabilities = capabilities
}

lspconfig.pyright.setup{
  capabilities = capabilities
}

lspconfig.ruby_lsp.setup{
  cmd = { "bundle", "exec", "ruby-lsp" },
  capabilities = capabilities
}

