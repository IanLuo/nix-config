-- Autocompletion setup
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Safe loading of required plugins
local cmp_status, cmp = pcall(require, 'cmp')
if not cmp_status then
    print("nvim-cmp not found!")
    return
end

local luasnip_status, luasnip = pcall(require, "luasnip")
local cmp_autopairs_status, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
local lspkind_status, lspkind = pcall(require, 'lspkind')

-- Initialize LuaSnip with safe configuration if available
if luasnip_status then
    luasnip.config.setup({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
    })
end

if cmp_autopairs_status then
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
end

cmp.setup({
    completion = {
        completeopt = 'menu,menuone,noselect'
    },
    snippet = luasnip_status and {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    } or {},
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_next_item()
        --     elseif luasnip.expand_or_jumpable() then
        --         luasnip.expand_or_jump()
        --     elseif has_words_before() then
        --         cmp.complete()
        --     else
        --         fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
        --     end
        -- end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip_status and luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end, { "i", "s" })
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
    }, {
        { name = 'buffer' },
    }),
    formatting = {
        format = lspkind_status and lspkind.cmp_format() or nil,
    },
    experimental = {
        ghost_text = true;
    }
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
   sources = cmp.config.sources({
       { name = 'path' }
   }, {
       { name = 'cmdline' }
   })
})
