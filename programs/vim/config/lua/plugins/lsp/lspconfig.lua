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

local keymap = vim.keymap -- for conciseness

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	require("illuminate").on_attach(client)

	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
	require("legendary").keymaps({
		{ "gD", vim.lsp.buf.declaration, description = "LSP: Go to declaration", opts = opts },
		{ "gd", vim.lsp.buf.definition, description = "LSP: Go to definition", opts = opts },
		{ "K", vim.lsp.buf.hover, description = "LSP: Hover", opts = opts },
		{ "gi", vim.lsp.buf.implementation, description = "LSP: Go to implementation", opts = opts },
		{ "<C-s>", vim.lsp.buf.signature_help, description = "LSP: Signature help", mode = { "n", "i" }, opts = opts },
		{ "<space>wa", vim.lsp.buf.add_workspace_folder, description = "LSP: Add workspace folder", opts = opts },
		{ "<space>wr", vim.lsp.buf.remove_workspace_folder, description = "LSP: Remove workspace folder", opts = opts },
		{
			"<space>wl",
			function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end,
			description = "LSP: List workspaces",
			opts = opts,
		},
		{ "<space>D", vim.lsp.buf.type_definition, description = "LSP: Show type definition", opts = opts },
		{ "<space>rn", vim.lsp.buf.rename, description = "LSP: Rename", opts = opts },
		{ "<space>ca", vim.lsp.buf.code_action, description = "LSP: Code Action", opts = opts },
		{ "gr", vim.lsp.buf.references, description = "LSP: Show references", opts = opts },
		{
			"<space>e",
			function()
				vim.diagnostic.open_float(0, { scope = "line" })
			end,
			description = "Diagnostics: Show window",
			opts = opts,
		},
		{
			"[d",
			function()
				vim.diagnostic.goto_prev({ float = { border = "single" } })
			end,
			description = "Diagnostics: Previous",
			opts = opts,
		},
		{
			"]d",
			function()
				vim.diagnostic.goto_next({ float = { border = "single" } })
			end,
			description = "Diagnostics: Next",
			opts = opts,
		},
		{ "<space>q", vim.diagnostic.setloclist, description = "Diagnostic: Show location list", opts = opts },
		{ "<space>f", vim.lsp.buf.formatting, description = "LSP: Format file", opts = opts },
		{
			"]u",
			function()
				require("illuminate").next_reference({ wrap = true })
			end,
			description = "Illuminate: Next reference",
			opts = opts,
		},
		{
			"[u",
			function()
				require("illuminate").next_reference({ reverse = true, wrap = true })
			end,
			description = "Illuminate: Previous reference",
			opts = opts,
		},
	})
end
--
-- -- used to enable autocompletion (assign to every lsp server config)
local capabilities = require("cmp_nvim_lsp").default_capabilities()
--
-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local notify = require("notify")
vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
	notify({ result.message }, lvl, {
		title = "LSP | " .. client.name,
		timeout = 10000,
		keep = function()
			return lvl == "ERROR" or lvl == "WARN"
		end,
	})
end

vim.lsp.handlers["textDocument/references"] = require("telescope.builtin").lsp_references

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
