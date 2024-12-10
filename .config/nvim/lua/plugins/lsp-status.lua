local lsp_status = require('lsp-status')
lsp_status.config({
    diagnostics = false, --The diagnostics is shown in the lualine
    current_function = false, --The current function is shown in the lualine
    indicator_ok = '',
    status_symbol = ''
})

lsp_status.register_progress()
