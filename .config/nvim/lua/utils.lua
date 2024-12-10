local M = {}

function M.set_highlight(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

function M.map(mode, lhs, rhs, opts)
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

function M.nmap(lhs, rhs, opts)
    M.map('n', lhs, rhs, opts)
end

return M
