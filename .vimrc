"----------------- Options -----------------{{{1
syntax enable
syntax on
set cmdheight=2
set backspace=indent,eol,start
set termguicolors "开启真彩色
set fdm=marker
set cindent     "设置C样式的缩进格式"
set tabstop=4   "设置table长度"
set shiftwidth=4        "同上"
set expandtab
set hlsearch " 高亮搜索
set incsearch " 实时搜索 
set ignorecase " 忽略大小写
set cursorline "高亮光标所在行
set number "显示行号
set mouse=a "永远使用鼠标
" 分割线变为空格
"set fillchars=vert:\ 
let mapleader="," "leader键变为逗号
set signcolumn=yes
set wildmenu 
"set showmatch   "显示匹配的括号"
set scrolloff=3 "显示光标上下文
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=100

set showbreak=↪
set breakindent

" 延迟绘制（提升性能）
"set lazyredraw

" quickfix 隐藏行号
augroup VimInitStyle
	au!
	au FileType qf setlocal nonumber
augroup END

set shada=!,'10000,<50,s10,h "keep 10000 lines of file history and 50 lines of command line history

"----------------- Plugins ----------------- {{{1
call plug#begin('~/.vim/plugged')
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
Plug 'mhinz/vim-signify' "vim sign bar显示git 状态

" Status lines
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-lua/lsp-status.nvim'
" Plug 'itchyny/lightline.vim' "vim 状态栏

Plug 'scrooloose/nerdcommenter' "注释插件
Plug 'christoomey/vim-tmux-navigator' " tmux 与 vim 集成，Ctrl + hjkl 切换窗口
"Plug 'majutsushi/tagbar' "显示tag 
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } "模糊搜索
Plug 'junegunn/fzf.vim' "模糊搜索
"Plug 'junegunn/seoul256.vim'
Plug 'r0mai/vim-djinni' "djinni support
Plug 'ranjithshegde/ccls.nvim'
Plug 'mtdl9/vim-log-highlighting' "log hilight
Plug 'rhysd/git-messenger.vim' "show git blame on current line
Plug 'tpope/vim-fugitive' "Gblame
" Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'godlygeek/tabular' "markdown highlighting
Plug 'plasticboy/vim-markdown'
Plug 'keith/swift.vim' "swift support
Plug 'phaazon/hop.nvim' "vim-easymotion alternative
" Plug 'ingjieye/vim_current_word' "highlighting current word
Plug 'kyazdani42/nvim-web-devicons' "filetree icon
Plug 'kyazdani42/nvim-tree.lua' "filetree
Plug 'aklt/plantuml-syntax' "dependency for weirongxu/plantuml-previewer.vim
Plug 'tyru/open-browser.vim' "dependency for weirongxu/plantuml-previewer.vim
Plug 'weirongxu/plantuml-previewer.vim' "preview plantUML
"Plug 'nathom/filetype.nvim' "speedup filetype detection -> disable due to conflict with plantuml-syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} "syntax hilighting
Plug 'nvim-treesitter/playground' "TSHighlightCapturesUnderCursor
Plug 'nvim-neotest/nvim-nio' "dependency for dap and neotest
Plug 'mfussenegger/nvim-dap' "lldb support in nvim
Plug 'rcarriga/nvim-dap-ui' "lldb support in nvim
" Plug 'github/copilot.vim' "github copilot
Plug 'nvim-lua/plenary.nvim' "dependency for telescope and neotest
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } "dependency for telescope
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
Plug 'kevinhwang91/nvim-bqf' "better quickfix window
Plug 'ingjieye/papercolor-theme' "colorscheme
Plug 'pappasam/papercolor-theme-slim'
Plug 'nvim-neotest/neotest'
Plug 'windwp/nvim-autopairs'
Plug 'alfaix/neotest-gtest'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'zbirenbaum/copilot.lua'
Plug 'CopilotC-Nvim/CopilotChat.nvim'
Plug 'zbirenbaum/copilot-cmp'
call plug#end()

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
colorscheme PaperColorSlim

"----------------- Plugin Options ----------------- {{{1
"----------------- coc.nvim ----------------- {{{2
" if !empty(glob($HOME."/.vim/plugged/coc.nvim"))
"     " coc extensions
"     let g:coc_global_extensions = ['coc-snippets', 'coc-pyright', 'coc-tsserver', 'coc-nav']
"     
"     "Some servers have issues with backup files, see #649
"     set nobackup
"     set nowritebackup
" 

" 
"     function! CheckBackspace() abort
"       let col = col('.') - 1
"       return !col || getline('.')[col - 1]  =~# '\s'
"     endfunction
" 
"     function! ShowDocumentation()
"       if CocAction('hasProvider', 'hover')
"         call CocActionAsync('doHover')
"       else
"         call feedkeys('K', 'in')
"       endif
"     endfunction
" 
"     " Highlight symbol under cursor on CursorHold, put it after colorscheme
"     " settings to override.
"     autocmd CursorHold * silent call CocActionAsync('highlight')
"     augroup mygroup
"       autocmd!
"       " Setup formatexpr specified filetype(s).
"       autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"       " Update signature help on jump placeholder.
"       autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"     augroup end
" 
"     " Use `:Fold` to fold current buffer
"     command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" 
"     let g:coc_snippet_next = '<Tab>'
"     let g:coc_snippet_prev = '<S-Tab>'
"     let g:coc_status_error_sign = '✘ '
" 
" 
" endif
"let g:cpp_member_variable_highlight = 1


"----------------- vim-signify --------------- {{{2
let g:signify_sign_show_count = 0
let g:signify_realtime = 0 "实时
let g:signify_sign_add               = ' '
let g:signify_sign_change            = ' '
let g:signify_sign_change_delete     = ' '
let g:signify_sign_delete_first_line = ' '


"----------------- lightline --------------- {{{2
if !empty(glob($HOME."/.vim/plugged/lightline.vim"))

set noshowmode " -- INSERT -- is unnecessary anymore because the mode information is displayed in the statusline.
autocmd User CocStatusChange redrawstatus "Update status line when CocStatusChange
autocmd User CocNavChanged redrawstatus "Update status line when CocNavChanged

function! NearestMethodOrFunction() abort
  let ret = ''
  let nav = get(b:, 'coc_nav', '')
  if (len(nav)) != 0
    if (has_key(nav[len(nav) - 1], 'name'))
        let ret = nav[len(nav) - 1]['name']
    endif
  endif
  return ret
endfunction

let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             ['readonly', 'filename', 'modified', 'method', 'cocstatus'] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'filename': 'LightlineFilename',
      \   'method': 'NearestMethodOrFunction'
      \ },
      \ }
" show relative file path for lightline.
" require vim-fugitive
" https://github.com/itchyny/lightline.vim/issues/293
function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction
endif
"golang {{{3
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

"----------------- scrooloose/nerdcommenter --------------- {{{2
" Create default mappings
let g:NERDCreateDefaultMappings = 0
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

"----------------- fzf --------------- {{{2
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%'), <bang>0)

command! -bang -nargs=* Rgi
  \ call fzf#vim#grep(
  \   'rg --no-ignore --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%'), <bang>0)
"command! -bang -nargs=* Ag
"\ call fzf#vim#ag(<q-args>,
"\                 <bang>0 ? fzf#vim#with_preview('up:60%')
"\                         : fzf#vim#with_preview('right:50%:hidden', '?'),
"\                 <bang>0)

function! s:build_quickfix_list(lines)
  if len(a:lines) == 1
    execute 'tabedit' a:lines[0]
  else
    call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
    copen
    cc
  endif
endfunction

let g:fzf_action = {
  \ 'ctrl-t': function('s:build_quickfix_list'),
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let $FZF_DEFAULT_OPTS = '--bind ctrl-o:select-all'

" let g:fzf_layout = { 'window': { 'width': 0.4, 'height': 1, 'xoffset': 0, 'border': 'right' } }
let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.7 } }
" let g:fzf_layout = { 'left': '~40%' }

"----------------- tagbar --------------- {{{2
let g:tagbar_width = 30

"----------------- git-messenger --------------- {{{2
let g:git_messenger_date_format = "%Y-%m-%d %X"


"----------------- vim-markdown --------------- {{{2
let g:vim_markdown_folding_disabled = 1

"----------------- phaazon/hop --------------- {{{2
if !empty(glob($HOME."/.vim/plugged/hop.nvim"))
    lua require'hop'.setup()
endif
"----------------- dominikduda/vim_current_word --------------- {{{2
let g:vim_current_word#highlight_delay = 200
hi CurrentWord guibg=#474e52
hi CurrentWordTwins guibg=#474e52
let g:vim_current_word#included_filetypes = ['log']


"----------------- weirongxu/plantuml-previewer.vim --------------- {{{2
au FileType plantuml let g:plantuml_previewer#plantuml_jar_path = get(
    \  matchlist(system('cat `which plantuml` | grep plantuml.jar'), '\v.*\s[''"]?(\S+plantuml\.jar).*'),
    \  1,
    \  0
    \)




"----------------- Keybindings -----------------{{{1
" ----------------- Reference ----------------- {{{2
"COMMANDS                    MODES ~
":map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
":nmap  :nnoremap :nunmap    Normal
":vmap  :vnoremap :vunmap    Visual and Select
":smap  :snoremap :sunmap    Select
":xmap  :xnoremap :xunmap    Visual
":omap  :onoremap :ounmap    Operator-pending
":map!  :noremap! :unmap!    Insert and Command-line
":imap  :inoremap :iunmap    Insert
":lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arg
":cmap  :cnoremap :cunmap    Command-line
"
" Prefixs
" <S-X>: Shift + X
" <M-X>: Alt(Meta) + X
" <C-X>: Ctrl + X
" <Leader>: Leader key, set in mapleader, currently ','
"
" Use :Maps to show all Keybindings (supported by FZF)

" ----------------- No Prefix ----------------- {{{2
" nnoremap <silent> = :exe "resize " . (winheight(0) * 3/2) <cr>
" nnoremap <silent> - :exe "resize " . (winheight(0) * 2/3) <cr>
" nnoremap <silent> + :exe "vertical resize " . (winwidth(0) * 4/3) <cr>
" nnoremap <silent> _ :exe "vertical resize " . (winwidth(0) * 3/4) <cr>
" nnoremap <silent> - :exe "resize " . (winheight(0) * 2/3) <cr>
" nnoremap <silent> + :exe "vertical resize " . (winwidth(0) * 4/3) <cr>
" nnoremap <silent> _ :exe "vertical resize " . (winwidth(0) * 3/4) <cr>
" nnoremap <silent> H :noh<Enter>
" nnoremap <silent> s :HopChar2<CR>
" nnoremap <silent> xc :CclsCallHierarchy<cr>
" inoremap <silent><expr> <Tab>
"   \ coc#pum#visible() ? coc#pum#next(1) :
"   \ coc#expandableOrJumpable() ? "\<C-r>=coc#snippet#next()\<CR>" :
"   \ CheckBackspace() ? "\<Tab>" :
"   \ coc#refresh()
" inoremap <silent><expr> <S-Tab>
"   \ coc#pum#visible() ? coc#pum#prev(1) :
"   \ coc#expandableOrJumpable() ? "\<C-r>=coc#snippet#prev()\<CR>" :
"   \ CheckBackspace() ? "\<S-Tab>" :
"   \ coc#refresh()
" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              " \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Map the 'q' key to call the CloseQuickfix function only when the quickfix window is open
" nnoremap <silent><expr> q getwinvar(winnr(), '&buftype') ==# 'quickfix' ? ':cclose<CR>' : 'q'
" ----------------- Alt(meta/option) ----------------- {{{2
" nnoremap <silent> <M-1> :tabnext 1<cr>
" nnoremap <silent> <M-2> :tabnext 2<cr>
" nnoremap <silent> <M-3> :tabnext 3<cr>
" nnoremap <silent> <M-4> :tabnext 4<cr>
" nnoremap <silent> <M-5> :tabnext 5<cr>

" ----------------- Ctrl ----------------- {{{2
" noremap  <silent> <C-S> :update<CR>
" vnoremap <silent> <C-S> <C-C>:update<CR>
" inoremap <silent> <C-S> <Esc>:update<CR>
"Map <C-P> and <C-N> to Jump between coc diagnostics and quickfix, if no quickfix, then jump between coc diagnostics
" nnoremap <silent><expr> <C-P> (len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')) == 0 ? '<Plug>(coc-diagnostic-prev)' : ':cp<CR>')
" nnoremap <silent><expr> <C-N> (len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')) == 0 ? '<Plug>(coc-diagnostic-next)' : ':cn<CR>')
" nnoremap <silent> <C-F> :FZF<CR>

" if has('nvim')
  " inoremap <silent><expr> <C-space> coc#refresh()
" else
  " inoremap <silent><expr> <C-@> coc#refresh()
" endif


" imap <silent><expr> <C-L> exists('b:_copilot.suggestions') ? copilot#Accept("\<CR>") : copilot#Suggest()

" ----------------- Leader ----------------- {{{2
" nnoremap <leader>rn <Plug>(coc-rename)

"<leader>c : code related action
" nnoremap <silent><leader>cf <Plug>(coc-format-selected)l
" xnoremap <silent><leader>cf <Plug>(coc-format-selected)
" nnoremap <silent><leader>cc <Plug>NERDCommenterToggle
" vnoremap <silent><leader>cc <Plug>NERDCommenterToggle

" nnoremap <silent><leader>ac <Plug>(coc-codeaction)
" nnoremap <silent><leader>qf <Plug>(coc-fix-current)

" nnoremap <silent><leader>ne :NvimTreeToggle<cr> 
" nnoremap <silent><leader>nf :NvimTreeFindFile<cr> 

" nnoremap <silent><leader>cg :TSHighlightCapturesUnderCursor<CR>
" nnoremap <silent><leader>gd :call CocAction('jumpDefinition', 'vsplit')<CR>zz
" nnoremap <silent><leader>gt :call CocAction('jumpDefinition', 'tabe')<CR>

"<leader>d : dap
"nnoremap <silent><leader>dk :lua require'dap'.step_out()<CR>
"nnoremap <silent><leader>dl :lua require'dap'.step_into()<CR>
"nnoremap <silent><leader>dj :lua require'dap'.step_over()<CR>
"nnoremap <silent><leader>dc :lua require'dap'.continue()<CR>
"nnoremap <silent><leader>db :lua require'dap'.toggle_breakpoint()<CR>
"nnoremap <silent><leader>d_ :lua require'dap'.run_last()<CR>
"nnoremap <silent><leader>ds :lua require'dap'.terminate()<CR>
"nnoremap <silent><leader>du :lua require'dapui'.toggle()<CR>

"<leader>f : Telescope
" nnoremap <silent><leader>ff :Telescope<CR>
" nnoremap <silent><leader>fg :Telescope live_grep<CR>
" nnoremap <silent><leader>fb :Telescope buffers<CR>

" ----------------- Space ----------------- {{{2
" nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" map <silent> <space>cc :CopilotChatOpen<CR>
