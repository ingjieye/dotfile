local set_highlight = require('utils').set_highlight

set_highlight('BqfPreviewFloat',      { link = 'Normal' })
set_highlight('BqfPreviewBorder',     { link = 'FloatBorder' })
set_highlight('BqfPreviewTitle',      { link = 'Title' })
set_highlight('BqfPreviewThumb',      { link = 'PmenuThumb' })
set_highlight('BqfPreviewSbar',       { link = 'PmenuSbar' })
set_highlight('BqfPreviewCursor',     { link = 'Search' })
set_highlight('BqfPreviewCursorLine', { link = 'CursorLine' })
set_highlight('BqfPreviewRange',      { link = 'IncSearch' })
set_highlight('BqfPreviewBufLabel',   { link = 'BqfPreviewRange' })

set_highlight('BqfPreviewBorder', { fg = '#3e8e2d', ctermfg = 71 })
set_highlight('BqfPreviewTitle',  { fg = '#3e8e2d', ctermfg = 71 })
set_highlight('BqfPreviewThumb',  { bg = '#3e8e2d', ctermbg = 71 })

require('bqf').setup({
    auto_enable = true,
    auto_resize_height = true, -- highly recommended enable
    preview = {
        winblend = 5,
        win_height = 48,
        win_vheight = 12,
        delay_syntax = 0,
        border = 'double',
        show_title = true,
        should_preview_cb = function(bufnr, qwinid)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname:match('^fugitive://') then
                -- skip fugitive buffer
                ret = false
            end
            return ret
        end
    },

    -- zf to toggle fzf, in fzf, enter regex to filter result, and then
    -- C-a to select all, C-t to open new quickfix window using selected one

    func_map = {
        open = 'o', --  open the item under the cursor                             
        openc = '<CR>', --  open the item, and close quickfix window                   
        drop = 'O', --  use `drop` to open the item, and close quickfix window     
        tabdrop = '', --  use `tab drop` to open the item, and close quickfix window 
        tab = 't', --  open the item in a new tab                                 
        tabb = 'T', --  open the item in a new tab, but stay in quickfix window    
        tabc = '<C-t>', --  open the item in a new tab, and close quickfix window      
        split = '<C-x>', --  open the item in horizontal split                          
        vsplit = '<C-v>', --  open the item in vertical split                            
        prevfile = '', --  go to previous file under the cursor in quickfix window    
        nextfile = '', --  go to next file under the cursor in quickfix window        
        prevhist = '<', --  cycle to previous quickfix list in quickfix window         
        nexthist = '>', --  cycle to next quickfix list in quickfix window             
        lastleave = '\'"', --  go to last selected item in quickfix window                
        stoggleup = '<S-Tab>', --  toggle sign and move cursor up                             
        stoggledown = '<Tab>', --  toggle sign and move cursor down                           
        stogglevm = '<Tab>', --  toggle multiple signs in visual mode                       
        stogglebuf = '\'<Tab>', --  toggle signs for same buffers under the cursor             
        sclear = 'z<Tab>', --  clear the signs in current quickfix list                   
        pscrollup = '<C-b>', --  scroll up half-page in preview window                      
        pscrolldown = '<C-f>', --  scroll down half-page in preview window                    
        pscrollorig = 'zo', --  scroll back to original position in preview window         
        ptogglemode = 'zp', --  toggle preview window between normal and max size          
        ptoggleitem = 'p', --  toggle preview for a quickfix list item                    
        ptoggleauto = 'P', --  toggle auto-preview when cursor moves                      
        filter = 'zn', --  create new list for signed items                           
        filterr = 'zN', --  create new list for non-signed items                       
        fzffilter = 'zf', --  enter fzf mode                                             
    },
})
