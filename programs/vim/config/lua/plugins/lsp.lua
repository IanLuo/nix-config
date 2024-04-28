require("lspsaga").setup{}

local lspconfig = require('lspconfig')

lspconfig.nixd.setup{}

lspconfig.pyright.setup{}

lspconfig.solargraph.setup{
  cmd = {
    "solargraph",
    "stdio"
  },
  filetypes = {
    "ruby",
    "rakefile"
  },
  root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
  settings = {
    solargraph = {
      diagnostics = true,
    },
  },
}

