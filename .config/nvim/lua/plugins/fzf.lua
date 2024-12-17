-- FZF settings
vim.env.FZF_DEFAULT_OPTS = '--bind ctrl-o:select-all'
vim.g.fzf_layout = { window = { width = 0.7, height = 0.7 } }

-- Custom Rg commands
vim.cmd([[
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%'), <bang>0)

command! -bang -nargs=* Rgi
  \ call fzf#vim#grep(
  \   'rg --no-ignore --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%'), <bang>0)
]])

-- FZF action settings
vim.g.fzf_action = {
    ['ctrl-t'] = function(lines)
        if #lines == 1 then
            vim.cmd('tabedit ' .. lines[1])
        else
            local qf_list = {}
            for _, line in ipairs(lines) do
                table.insert(qf_list, { filename = line, lnum = 1 })
            end
            vim.fn.setqflist(qf_list)
            vim.cmd('copen')
            vim.cmd('cc')
        end
    end,
    ['ctrl-x'] = 'split',
    ['ctrl-v'] = 'vsplit'
} 