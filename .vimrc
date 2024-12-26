"----------------- Colorschemes ----------------- {{{1
" Color picker: https://www.w3schools.com/colors/colors_picker.asp
function! HighlightsForPaperColorSlim() abort
    if &background ==# 'light'
        highlight! Function                         guifg=#005faf guibg=NONE    gui=bold
        highlight! Constant                         guifg=#444444 guibg=NONE    gui=NONE
        highlight! DiffAdd                          guifg=#444444 guibg=#48985D gui=NONE
        highlight! DiffDelete                       guifg=#444444 guibg=#af0000 gui=NONE
        highlight! Search                           guifg=#444444 guibg=#ffff5f gui=NONE
        highlight! LineNr                           guifg=#b2b2b2 guibg=NONE    gui=NONE
        highlight! DiagnosticUnderLineError         guifg=#af0000 guibg=NONE    gui=undercurl
        highlight! DiagnosticUnderLineWarn          guifg=#af5f00 guibg=NONE    gui=undercurl
        highlight! DiagnosticUnderLineInfo          guifg=#005faf guibg=NONE    gui=undercurl
        highlight! DiagnosticUnderLineHint          guifg=#005f87 guibg=NONE    gui=undercurl
        highlight! DiagnosticUnderLineOk            guifg=#008700 guibg=NONE    gui=undercurl

        highlight! link @type                                  NormalNC
        highlight! link @type.builtin                          @keyword
        highlight! link @constant.builtin                      @keyword
        highlight! link @operator                              NormalNC
        highlight! link @variable                              NormalNC
        highlight! link @punctuation                           NormalNC

        highlight! link CocSymbolVariable                      NormalNC
        highlight! link CocSymbolReference                     NormalNC

    endif
endfunction

function! HighlightsForCoc() abort
    if &background ==# 'dark'
      hi default CocHighlightText  guibg=#474e52
    else
      hi default CocHighlightText  guibg=#bfbfbf
    endif
endfunction

function! HighlightsForAll() abort
    highlight! SignColumn guibg=NONE " make signcolumn transparent
endfunction

augroup MyColors
    autocmd!
    autocmd ColorScheme PaperColorSlim call HighlightsForPaperColorSlim()
    autocmd ColorScheme *              call HighlightsForCoc()
    autocmd ColorScheme *              call HighlightsForAll()
augroup END

set background=light
