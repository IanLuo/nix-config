-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

-- import typescript plugin safely
local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
	return
end

local keymap = vim.keymap -- for conciseness

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
  require('legendary').keymaps({
  { 'gD', vim.lsp.buf.declaration, description = 'LSP: Go to declaration', opts = opts },
        { 'gd', vim.lsp.buf.definition, description = 'LSP: Go to definition', opts = opts },
        { 'K', vim.lsp.buf.hover, description = 'LSP: Hover', opts = opts },
        { 'gi', vim.lsp.buf.implementation, description = 'LSP: Go to implementation', opts = opts },
        { '<C-s>', vim.lsp.buf.signature_help, description = 'LSP: Signature help', mode = { 'n', 'i' }, opts = opts },
        { '<space>wa', vim.lsp.buf.add_workspace_folder, description = 'LSP: Add workspace folder', opts = opts },
        { '<space>wr', vim.lsp.buf.remove_workspace_folder, description = 'LSP: Remove workspace folder', opts = opts },
        { '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, description = 'LSP: List workspaces', opts = opts },
        { '<space>D', vim.lsp.buf.type_definition, description = 'LSP: Show type definition', opts = opts },
        { '<space>rn', vim.lsp.buf.rename, description = 'LSP: Rename', opts = opts },
        { '<space>ca', vim.lsp.buf.code_action, description = 'LSP: Code Action', opts = opts },
        { 'gr', vim.lsp.buf.references, description = 'LSP: Show references', opts = opts },
        { '<space>e', function() vim.diagnostic.open_float(0, {scope="line"}) end, description = 'Diagnostics: Show window', opts = opts },
        { '[d', function() vim.diagnostic.goto_prev({ float =  { border = "single" }}) end, description = 'Diagnostics: Previous', opts = opts },
        { ']d', function() vim.diagnostic.goto_next({ float =  { border = "single" }}) end, description = 'Diagnostics: Next', opts = opts },
        { '<space>q', vim.diagnostic.setloclist, description = 'Diagnostic: Show location list', opts = opts },
        { '<space>f', vim.lsp.buf.formatting, description = 'LSP: Format file', opts = opts },
        { ']u', function() require('illuminate').next_reference({ wrap = true }) end, description = "Illuminate: Next reference", opts = opts },
        { '[u', function() require('illuminate').next_reference({ reverse = true, wrap = true }) end, description = "Illuminate: Previous reference", opts = opts }
  })
	--   -- typescript specific keymaps (e.g. rename file and update imports)
	--   if client.name == "tsserver" then
	--     keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
	--     keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
	--     keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
	--   end
end
--
-- -- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()
--
-- -- Change the Diagnostic symbols in the sign column (gutter)
-- -- (not in youtube nvim video)
-- local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
-- for type, icon in pairs(signs) do
--   local hl = "DiagnosticSign" .. type
--   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
-- end
--
-- -- configure html server
-- lspconfig["html"].setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
-- })
--
-- -- configure typescript server with plugin
-- typescript.setup({
--   server = {
--     capabilities = capabilities,
--     on_attach = on_attach,
--   },
-- })
--
-- -- configure css server
-- lspconfig["cssls"].setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
-- })
--
-- -- configure tailwindcss server
-- lspconfig["tailwindcss"].setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
-- })
--
-- -- configure emmet language server
-- lspconfig["emmet_ls"].setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
--   filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
-- })

-- configure lua server (with special settings)
lspconfig["lua_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})
