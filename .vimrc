"Options {{{1

syntax enable
set cmdheight=2

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" "tmux + vim 开启真彩色 https://github.com/tmux/tmux/issues/1246
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
set backspace=indent,eol,start
set t_Co=&term
set termguicolors "开启真彩色
set fdm=marker
set cindent     "设置C样式的缩进格式"
set tabstop=4   "设置table长度"
set shiftwidth=4        "同上"
set expandtab
set hlsearch " 高亮搜索
set incsearch " 实时搜索 
set cursorline "高亮光标所在行
set number "显示行号
set mouse=a "永远使用鼠标
"分割线变为空格
set fillchars=vert:\ 
let mapleader="," "leader键变为逗号
"signcolumn
autocmd BufRead,BufNewFile * setlocal signcolumn=yes
autocmd FileType tagbar,nerdtree setlocal signcolumn=no
set wildmenu 
"set showmatch   "显示匹配的括号"
set scrolloff=3 "显示光标上下文

"忘记打sudo，打w!!可写
cnoremap w!! %!sudo tee > /dev/null %

packadd termdebug
set showbreak=↪
set breakindent

"切换tab快捷键
nn <M-down> :lnext<cr>zvzz
nn <M-up> :lprevious<cr>zvzz
nn <M-1> :tabnext 1<cr>
nn <M-2> :tabnext 2<cr>
nn <M-3> :tabnext 3<cr>
nn <M-4> :tabnext 4<cr>
nn <M-5> :tabnext 5<cr>
"for macos
nn ¡ :tabnext 1<cr>
nn ™ :tabnext 2<cr>
nn £ :tabnext 3<cr>
nn ¢ :tabnext 4<cr>
nn ∞ :tabnext 5<cr>

"快捷键保存
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <Esc>:update<CR>

"快捷键清除搜索高亮
nnoremap H :noh<Enter>

"Colorschemes {{{1
set background=dark
"colorscheme gruvbox
"colorscheme molokai
colorscheme hybrid
"colorscheme embark
"colorscheme space-vim-dark
"let g:seoul256_background = 234
"let g:seoul256_srgb = 1
"colorscheme seoul256
"Plugins {{{1
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree' "树形目录
Plug 'Xuyuanp/nerdtree-git-plugin' "netdtree 显示git状态
Plug 'octol/vim-cpp-enhanced-highlight' "c++高亮
Plug 'mhinz/vim-signify', {'commit': 'd80e507'} "vim sign bar显示git 状态
Plug 'itchyny/lightline.vim' "vim 状态栏
Plug 'scrooloose/nerdcommenter' "注释插件
Plug 'christoomey/vim-tmux-navigator' " tmux 与 vim 集成，Ctrl + hjkl 切换窗口
Plug 'majutsushi/tagbar' "显示tag 
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } "模糊搜索
Plug 'junegunn/fzf.vim' "模糊搜索
Plug 'junegunn/seoul256.vim'
Plug 'r0mai/vim-djinni' "djinni support
Plug 'm-pilia/vim-ccls' " supports some additional methods provided by ccls
Plug 'mtdl9/vim-log-highlighting' "log hilight
Plug 'rhysd/git-messenger.vim' "show git blame on current line
Plug 'tpope/vim-fugitive' "Gblame
call plug#end()

"Plugin settings {{{2
"coc.nvim配置 {{{3
" caller
nn <silent> gc :call CocLocations('ccls','$ccls/call')<cr>
" callee
nn <silent> gC :call CocLocations('ccls','$ccls/call',{'callee':v:true})<cr>
" if hidden is not set, TextEdit might fail.
set hidden
"
" " Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=200

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

" Use <s-space> to trigger completion.
inoremap <silent><expr> <S-Space> coc#refresh()

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold, put it after colorscheme
" settings to override.
hi default CocHighlightText guibg=#474e52
hi default CocMenuSel guibg=#282a2e
"hi CocCurrentLine guibg=#000000 guifg=#ffffff
"hi default link CocHighlightRead  CocHighlightText
"hi default link CocHighlightWrite  CocHighlightText
autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd CursorHoldI * sil call CocActionAsync('showSignatureHelp')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
"noremap <leader>f  :Neoformat<cr> 
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> <leader>gd <C-w>s<Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references-used)
"nmap <silent> gr :call LanguageClient#textDocument_references({'includeDeclaration': v:false})<cr>

" crossreference
" bases
nn <silent> xb :call CocLocations('ccls','$ccls/inheritance')<cr>
nn <silent> xd :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true})<cr>
" caller
nn <silent> xc :call CocLocations('ccls','$ccls/call')<cr>

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

"NERDTree 配置 {{{3
autocmd vimenter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd VimEnter * wincmd p

let g:NERDTreeGitStatusIndicatorMapCustom = {
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

let g:NERDTreeWinSize=25

let g:NERDTreeMapJumpPrevSibling="" "防止与vim-tmux-navigator 的按键冲突导光标在nerdtree中时无法移动到tmux窗口
let g:NERDTreeMapJumpNextSibling=""

nmap <leader>ne :NERDTreeToggle<cr> 
nmap <leader>nf :NERDTreeFind<cr> 

"CHADTree 配置 {{{3
"autocmd vimenter * CHADopen
"lua vim.api.nvim_set_var("chadtree_settings", { width = 35 })
"let g:chadtree_settings = {"use_icons": 0 }

"vim-signify 配置 {{{3
let g:signify_sign_show_text = 0
let g:signify_sign_show_count = 0
let g:signify_sign_delete_first_line = '-'
let g:signify_realtime = 0 "实时

" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }
"golang {{{3
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

"vim-tmux-navigator设置 {{{3
if exists(':tnoremap')
 tnoremap <silent> <c-h> <c-w>:TmuxNavigateLeft<cr>
 tnoremap <silent> <c-j> <c-w>:TmuxNavigateDown<cr>
 tnoremap <silent> <c-k> <c-w>:TmuxNavigateUp<cr>
 tnoremap <silent> <c-l> <c-w>:TmuxNavigateRight<cr>
 tnoremap <silent> <c-\> <c-w>:TmuxNavigatePrevious<cr>
endif

"fzf设置 {{{3
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%'), <bang>0)
let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.7 } }
nmap <silent> <C-F> :FZF<CR>

"tagbar设置 {{{3
let g:tagbar_width = 30


"git-messenger {{{3
let g:git_messenger_date_format = "%Y-%m-%d %X"
