-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

    local function map(mode, lhs, rhs, opts)
        local options = {noremap = true, silent = true}
        if opts then
            if type(opts) == 'string' then
                opts = {desc = opts}
            end
            options = vim.tbl_extend('force', options, opts)
        end
        if type(opts) == 'string' then
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
        else
            vim.keymap.set(mode, lhs, rhs, {buffer=true})
        end
    end

    local function nmap(lhs, rhs, opts)
        map('n', lhs, rhs, opts)
    end

    local function buf_set_option(name, value) vim.api.nvim_set_option_value(name, value, {scope='local'}) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- Jump to Definitions
    nmap('gd', '<cmd>Telescope lsp_definitions<cr>', 'Definitions')
    nmap('<leader>gd', "<cmd>lua require('telescope.builtin').lsp_definitions({ jump_type='vsplit' })<cr>", 'Definitions')
    nmap('gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', 'Declarations')

    local function custom_references()
        local params = vim.lsp.util.make_position_params()
        params.context = {
            includeDeclaration = false,
        }
        vim.lsp.buf_request(0, 'textDocument/references', params, function(err, result, ctx, config)
            if err or not result or vim.tbl_isempty(result) then
                return
            end
            if #result == 1 then
                vim.lsp.util.jump_to_location(result[1], client.offset_encoding)
            else
                vim.lsp.handlers['textDocument/references'](err, result, ctx, config)
            end
        end)
    end

    -- Jump to references
    -- nmap('gr', '<cmd>lua vim.lsp.buf.references({ includeDeclaration = false })<CR>', 'References')
    nmap('gr', custom_references, { desc = 'References' })
    nmap(',f', '<cmd>lua require("ccls.protocol").request("textDocument/references",{excludeRole=32})<cr>') -- not call
    nmap(',m', '<cmd>lua require("ccls.protocol").request("textDocument/references",{role=64})<cr>') -- macro
    nmap(',r', '<cmd>lua require("ccls.protocol").request("textDocument/references",{role=8})<cr>') -- read
    nmap(',w', '<cmd>lua require("ccls.protocol").request("textDocument/references",{role=16})<cr>') -- write

    -- Jump to type definition
    nmap('gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', 'Type definition')

    -- Action
    nmap('<leader>qf', '<cmd>lua vim.lsp.buf.code_action()<cr>') -- show code action (quick fix)
    nmap('<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename') -- rename
    nmap('<space>=', '<cmd>lua vim.lsp.buf.formatting()<cr>') --format
    map('v', '<leader>cf', '<cmd>lua vim.lsp.buf.format()<CR>') --format
    local function format_current_line()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        vim.lsp.buf.format({
            range = {
                start = {line - 1, 0},
                ["end"] = {line, 0},
            },
        })
    end
    nmap('<leader>cf', '<cmd>lua format_current_line()<CR>', {desc = 'Format current line'})

    -- Documentation
    nmap('K', '<cmd>lua vim.lsp.buf.hover()<cr>', 'Hover') -- show information about the code under the cursor
    nmap('<space>li', '<cmd>Inspect<cr>') -- Show inspect for current word
    nmap('<space>o', '<cmd>Telescope lsp_document_symbols<cr>') -- Show symbol for corrent document
    nmap('<space>s', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', 'Workspace symbols') --show symbol for current workspace

    -- Cross reference
    nmap('xB', '<cmd>CclsBaseHierarchy float<cr>')
    nmap('xC', '<cmd>CclsOutgoingCalls<cr>', 'callee')
    nmap('xD', '<cmd>CclsDerivedHierarchy float<cr>')
    nmap('xM', '<cmd>CclsMemberHierarchy float<cr>', 'member')
    nmap('xb', '<cmd>CclsBaseHierarchy float<cr>')
    nmap('xc', '<cmd>CclsIncomingCallsHierarchy float<cr>', 'caller')
    nmap('xd', '<cmd>CclsDerived<cr>')
    nmap('xi', '<cmd>lua vim.lsp.buf.implementation()<cr>', 'Implementation')
    nmap('xm', '<cmd>CclsMember<cr>', 'member')
    nmap('xn', function() M.lsp.words.jump(vim.v.count1) end, 'Next reference')
    nmap('xp', function() M.lsp.words.jump(-vim.v.count1) end, 'Prev reference')
    nmap('xv', '<cmd>CclsVars<cr>', 'vars')

    -- Unknown..
    nmap('<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>')
    map('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')

    nmap('<space>ls', function() require'my.util'.switch_source_header(0) end, 'Switch source and header')
    nmap('[e', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    nmap(']e', '<cmd>lua vim.diagnostic.goto_next()<cr>')

    -- Support code codeLens
    -- if client.supports_method 'textDocument/codeLens' then
    --     vim.api.nvim_create_autocmd({'BufEnter'}, {
    --         group = vim.api.nvim_create_augroup('lsp_buf_' .. bufnr, {clear = true}),
    --         buffer = bufnr,
    --         callback = function(ev)
    --             vim.lsp.codelens.refresh({bufnr = 0})
    --         end,
    --     })
    --     vim.lsp.codelens.refresh({bufnr = 0})
    -- end

    -- Support highlight current word
    if client.supports_method 'textDocument/documentHighlight' then
        vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI', 'CursorMoved', 'CursorMovedI'}, {
            group = vim.api.nvim_create_augroup('lsp_word_' .. bufnr, {clear = true}),
            buffer = bufnr,
            callback = function(ev)
                if ev.event:find('CursorMoved') then
                    vim.lsp.buf.clear_references()
                else
                    vim.lsp.buf.document_highlight()
                end

                require('lsp-status').update_current_function()
            end,
            desc = 'Document Highlight',
        })
    end

    -- Support show current function name
    if client.supports_method 'textDocument/documentSymbol' then
        vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI', 'CursorMoved', 'CursorMovedI'}, {
            group = vim.api.nvim_create_augroup('lsp_current_function_' .. bufnr, {clear = true}),
            buffer = bufnr,
            callback = function()
                require('lsp-status').update_current_function()
            end,
            desc = 'Current function',
        })
    end

end

local global_lsp_config =
{
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    }
}

local servers = {'ccls', 'lua_ls'}
local nvim_lsp = require('lspconfig')
for _, lsp in ipairs(servers) do
    local lspOptions = require('lsp.config.' .. lsp)
    local mergedOptions = vim.tbl_extend('force', global_lsp_config, lspOptions)
    nvim_lsp[lsp].setup(mergedOptions)
end

