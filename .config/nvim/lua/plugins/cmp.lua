local cmp = require('cmp')
cmp.setup {
    preselect = cmp.PreselectMode.None,
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                copilot = "[Copilot]",
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                ultisnips = "[UltiSnips]",
                nvim_lua = "[Lua]",
                cmp_tabnine = "[TabNine]",
                look = "[Look]",
                path = "[Path]",
                spell = "[Spell]",
                calc = "[Calc]",
                emoji = "[Emoji]"
            })[entry.source.name]
            return vim_item
        end
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-l>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<Enter>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        }),
    },
    sources = {
        {name = "copilot"},
        {name = 'nvim_lsp'},
        {name = 'buffer'},
    },
    completion = {completeopt = 'menu,menuone,noselect,noinsert'},
    experimental = {
        ghost_text = true,
    },
}
