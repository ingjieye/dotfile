call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
Plug 'scrooloose/nerdtree' "树形目录
Plug 'Xuyuanp/nerdtree-git-plugin' "netdtree 显示git状态
Plug 'octol/vim-cpp-enhanced-highlight' "c++高亮
Plug 'mhinz/vim-signify' "vim 显示git 状态
call plug#end()

"基本配置
syntax on
set cmdheight=2
"set hidden
"set noshowmode
set termguicolors "开启真彩色
set cindent     "设置C样式的缩进格式"
set tabstop=4   "设置table长度"
set shiftwidth=4        "同上"
set cursorline "高亮光标所在行
set number "显示行号
set signcolumn=yes "永远显示signcolumn
"set wildmenu 
"set showmatch   "显示匹配的括号"

"颜色主题
set background=dark
"colorscheme gruvbox
"colorscheme hybrid
colorscheme molokai

"coc.nvim 配置
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
"hi default CocHighlightText  guibg=Grey ctermbg=#ffff60
"hi default link CocHighlightRead  CocHighlightText
"hi default link CocHighlightWrite  CocHighlightText
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

"NERDTree 配置"
autocmd vimenter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "M",
    \ "Staged"    : "✚",
    \ "Untracked" : "U",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "!",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

"vim-signify 配置
let g:signify_sign_show_text = 0
let g:signify_sign_show_count = 0

"测试"
set showbreak=↪
set breakindent
