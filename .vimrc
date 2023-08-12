"Options {{{1
syntax enable
syntax on
set cmdheight=2
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" "tmux + vim 开启真彩色 https://github.com/tmux/tmux/issues/1246
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
set t_Co=&term
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
set fillchars=vert:\ 
let mapleader="," "leader键变为逗号
" signcolumn设置
autocmd BufRead,BufNewFile * setlocal signcolumn=yes
autocmd FileType tagbar,nerdtree setlocal signcolumn=no
set wildmenu 
"set showmatch   "显示匹配的括号"
set scrolloff=3 "显示光标上下文

"packadd termdebug
set showbreak=↪
set breakindent

" 延迟绘制（提升性能）
"set lazyredraw

" quickfix 隐藏行号
augroup VimInitStyle
	au!
	au FileType qf setlocal nonumber
augroup END

"Custom key maps{{{1
"
"Overview of which map command works in which mode.  More details below.
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

"- / = 调整窗口高度
"Shift + (- / =) 调整窗口宽度
nnoremap <silent> = :exe "resize " . (winheight(0) * 3/2) <cr>
nnoremap <silent> - :exe "resize " . (winheight(0) * 2/3) <cr>
nnoremap <silent> + :exe "vertical resize " . (winwidth(0) * 4/3) <cr>
nnoremap <silent> _ :exe "vertical resize " . (winwidth(0) * 3/4) <cr>
"双击Esc推出终端输入模式
"tnoremap <Esc><Esc> <C-\><C-n>
"忘记打sudo，打w!!可写
cnoremap w!! %!sudo tee > /dev/null %
"切换tab快捷键
nn <M-down> :lnext<cr>zvzz
nn <M-up> :lprevious<cr>zvzz
nn <silent> <M-1> :tabnext 1<cr>
nn <silent> <M-2> :tabnext 2<cr>
nn <silent> <M-3> :tabnext 3<cr>
nn <silent> <M-4> :tabnext 4<cr>
nn <silent> <M-5> :tabnext 5<cr>
"for macos
nn ¡ :tabnext 1<cr>
nn ™ :tabnext 2<cr>
nn £ :tabnext 3<cr>
nn ¢ :tabnext 4<cr>
nn ∞ :tabnext 5<cr>
"Ctrl-s 保存
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <Esc>:update<CR>
"快捷键清除搜索高亮
nnoremap H :noh<Enter>

"AsyncTask shortcuts
noremap <silent><f7> :AsyncTask assemble<cr>
noremap <silent><f6> :AsyncTask buildCore<cr>

"nmap <silent> <C-N> :cnext<CR>zz
"nmap <silent> <C-P> :cprev<CR>zz
nmap <silent> <C-N> <Plug>(coc-diagnostic-next)
nmap <silent> <C-P> <Plug>(coc-diagnostic-prev)


"Plugins {{{1
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
"Plug 'scrooloose/nerdtree' "树形目录
"Plug 'Xuyuanp/nerdtree-git-plugin' "netdtree 显示git状态
"Plug 'octol/vim-cpp-enhanced-highlight' "c++高亮
Plug 'bfrg/vim-cpp-modern' "c++高亮
"Plug 'jackguo380/vim-lsp-cxx-highlight' "C++ LSP高亮
Plug 'mhinz/vim-signify', {'commit': 'd80e507'} "vim sign bar显示git 状态
Plug 'itchyny/lightline.vim' "vim 状态栏
Plug 'scrooloose/nerdcommenter' "注释插件
Plug 'christoomey/vim-tmux-navigator' " tmux 与 vim 集成，Ctrl + hjkl 切换窗口
"Plug 'majutsushi/tagbar' "显示tag 
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } "模糊搜索
Plug 'junegunn/fzf.vim' "模糊搜索
"Plug 'junegunn/seoul256.vim'
Plug 'r0mai/vim-djinni' "djinni support
Plug 'm-pilia/vim-ccls' " supports some additional methods provided by ccls
Plug 'mtdl9/vim-log-highlighting' "log hilight
Plug 'rhysd/git-messenger.vim' "show git blame on current line
Plug 'tpope/vim-fugitive' "Gblame
Plug 'antoinemadec/FixCursorHold.nvim'
"Plug 'skywind3000/asynctasks.vim'
"Plug 'skywind3000/asyncrun.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'godlygeek/tabular' "markdown highlighting
Plug 'plasticboy/vim-markdown'
Plug 'liuchengxu/vista.vim' "show LSP symbols in side bar (and also status bar)
Plug 'vim-syntastic/syntastic' "swift support
Plug 'keith/swift.vim' "swift support
Plug 'phaazon/hop.nvim' "vim-easymotion alternative
"Plug 'kshenoy/vim-signature' "bookmark
Plug 'ingjieye/vim_current_word' "highlighting current word
Plug 'kyazdani42/nvim-web-devicons' "filetree icon
Plug 'kyazdani42/nvim-tree.lua' "filetree
Plug 'aklt/plantuml-syntax' "dependency for weirongxu/plantuml-previewer.vim
Plug 'tyru/open-browser.vim' "dependency for weirongxu/plantuml-previewer.vim
Plug 'weirongxu/plantuml-previewer.vim' "preview plantUML
"Plug 'nathom/filetype.nvim' "speedup filetype detection -> disable due to conflict with plantuml-syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} "syntax hilighting
Plug 'nvim-treesitter/playground' "TSHighlightCapturesUnderCursor
call plug#end()

"Colorschemes {{{1
set background=dark
"colorscheme gruvbox
"colorscheme molokai
"colorscheme solarized
"colorscheme space-vim-dark
"colorscheme apprentice
"colorscheme one
"colorscheme vim-material
"colorscheme badwolf

"let g:hybrid_custom_term_colors = 1
"let g:hybrid_reduced_contrast = 1
colorscheme hybrid

"let g:material_theme_style = 'lighter-community'
"colorscheme material

"let g:seoul256_background = 234
"let g:seoul256_srgb = 1
"let g:solarized_termcolors=256
"colorscheme seoul256

"colorscheme nord

"let ayucolor="dark"   " for dark version of theme
"let ayucolor="mirage" " for mirage version of theme
"colorscheme ayu

"let g:two_firewatch_italics=1
"colorscheme two-firewatch

"Plugin settings {{{1
"coc.nvim {{{2
if !empty(glob($HOME."/.vim/plugged/coc.nvim"))
    " caller
    nn <silent> gc :call CocLocations('ccls','$ccls/call')<cr>
    " callee
    nn <silent> gC :call CocLocations('ccls','$ccls/call',{'callee':v:true})<cr>

    " coc extensions
    let g:coc_global_extensions = ['coc-snippets', 'coc-pyright']
    
"----------------------- Refer from configuration in coc.nvim README.md -------------------------------- {{{3
    "Some servers have issues with backup files, see #649
    set nobackup
    set nowritebackup

    " Smaller updatetime for CursorHold & CursorHoldI
    set updatetime=200

    " Use tab for trigger completion with characters ahead and navigate
    inoremap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#pum#next(1) :
          \ CheckBackspace() ? "\<Tab>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Make <CR> to accept selected completion item or notify coc.nvim to format
    " <C-g>u breaks current undo, please make your own choice
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    " Use <c-space> to trigger completion
    if has('nvim')
      inoremap <silent><expr> <c-space> coc#refresh()
    else
      inoremap <silent><expr> <c-@> coc#refresh()
    endif

    " Use K to show documentation in preview window
    nnoremap <silent> K :call ShowDocumentation()<CR>
    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
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
    "autocmd CursorHoldI * sil call CocActionAsync('showSignatureHelp')
    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder.
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

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
    nn <silent> xd <Plug>(coc-implementation)
    " caller
    "nn <silent> xc :call CocLocations('ccls','$ccls/call')<cr> (see vim-ccls)

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

"----------------------- Refer from configuration in coc-snippets README.md -------------------------------- {{{3
    " Use <C-l> for trigger snippet expand.
    imap <C-l> <Plug>(coc-snippets-expand)

    " Use <C-j> for select text for visual placeholder of snippet.
    vmap <C-j> <Plug>(coc-snippets-select)

    " Use <C-j> for jump to next placeholder, it's default of coc.nvim
    let g:coc_snippet_next = '<c-j>'

    " Use <C-k> for jump to previous placeholder, it's default of coc.nvim
    let g:coc_snippet_prev = '<c-k>'

    " Use <C-j> for both expand and jump (make expand higher priority.)
    imap <C-j> <Plug>(coc-snippets-expand-jump)

    " Use <leader>x for convert visual selected code to snippet
    xmap <leader>x  <Plug>(coc-convert-snippet)

    inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#snippet#next()\<CR>" :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

    inoremap <silent><expr> <S-Tab>
      \ coc#pum#visible() ? coc#pum#prev(1) :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#snippet#prev()\<CR>" :
      \ CheckBackspace() ? "\<S-Tab>" :
      \ coc#refresh()

    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    let g:coc_snippet_next = '<Tab>'
    let g:coc_snippet_prev = '<S-Tab>'

    let g:coc_snippet_next = '<tab>'
endif
"NERDTree 配置 {{{2
"autocmd vimenter * NERDTree
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
let NERDTreeShowHidden=1

let g:NERDTreeWinSize=25

let g:NERDTreeMapJumpPrevSibling="" "防止与vim-tmux-navigator 的按键冲突导光标在nerdtree中时无法移动到tmux窗口
let g:NERDTreeMapJumpNextSibling=""

nmap <leader>ne :NERDTreeToggle<cr> 
nmap <leader>nf :NERDTreeFind<cr> 

"octol/vim-cpp-enhanced-highlight {{{2
"let g:cpp_member_variable_highlight = 1
"Plug 'bfrg/vim-cpp-modern' "c++高亮 {{{2
let g:cpp_attributes_highlight = 1
let g:cpp_member_highlight = 1
let g:cpp_simple_highlight = 1
"CHADTree 配置 {{{2
"autocmd vimenter * CHADopen
"lua vim.api.nvim_set_var("chadtree_settings", { width = 35 })
"let g:chadtree_settings = {"use_icons": 0 }

"vim-signify {{{2
let g:signify_sign_show_text = 0
let g:signify_sign_show_count = 0
let g:signify_sign_delete_first_line = '-'
let g:signify_realtime = 0 "实时

"lightline {{{2
if !empty(glob($HOME."/.vim/plugged/lightline.vim"))

set noshowmode " -- INSERT -- is unnecessary anymore because the mode information is displayed in the statusline.
autocmd User CocStatusChange redrawstatus "Fix status line can't auto update

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction
autocmd User CocStatusChange call vista#RunForNearestMethodOrFunction()
let g:lightline = {
      \ 'colorscheme': 'wombat',
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

"vim-tmux-navigator设置 {{{2
if exists(':tnoremap')
 tnoremap <silent> <c-h> <c-w>:TmuxNavigateLeft<cr>
 tnoremap <silent> <c-j> <c-w>:TmuxNavigateDown<cr>
 tnoremap <silent> <c-k> <c-w>:TmuxNavigateUp<cr>
 tnoremap <silent> <c-l> <c-w>:TmuxNavigateRight<cr>
 tnoremap <silent> <c-\> <c-w>:TmuxNavigatePrevious<cr>
endif

"fzf设置 {{{2
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

let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.7 } }
nmap <silent> <C-F> :FZF<CR>
if has("nvim")
    autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>
endif

"autocmd BufAdd NERD_tree_*,*.cpp,*.c,*.h,*.hpp,term* :let b:vim_current_word_disabled_in_this_buffer = 1
"tagbar设置 {{{2
let g:tagbar_width = 30

"git-messenger {{{2
let g:git_messenger_date_format = "%Y-%m-%d %X"
"vim-ccls {{{2
let g:ccls_size = 10
let g:ccls_position = 'botright'
let g:ccls_orientation = 'horizontal'
nn <silent> xc :CclsCallHierarchy<cr>
"asynctasks {{{2
let g:asyncrun_open = 6
let g:asynctasks_term_pos = 'tab'
let g:asyncrun_rootmarks = ['.root']
let g:asynctasks_term_focus = 0
let g:asynctasks_rtp_config = "asynctasks.ini"

"vim-markdown {{{2
let g:vim_markdown_folding_disabled = 1

"liuchengxu/vista.vim {{{2
let g:vista_echo_cursor = 0
let g:vista_default_executive = 'coc'
let g:vista#renderer#enable_icon = 1
let g:vista_cursor_delay = 0
"phaazon/hop {{{2
if !empty(glob($HOME."/.vim/plugged/hop.nvim"))
    lua require'hop'.setup()
    nnoremap s :HopChar2<CR>
endif
"kshenoy/vim-signature{{{2
"out of the box, the followings mappings are defined
"mx           Toggle mark 'x' and display it in the leftmost column
"dmx          Remove mark 'x' where x is a-zA-Z

"m,           Place the next available mark
"m.           If no mark on line, place the next available mark. Otherwise, remove (first) existing mark.
"m-           Delete all marks from the current line
"m<Space>     Delete all marks from the current buffer
"]`           Jump to next mark
"[`           Jump to prev mark
"]'           Jump to start of next line containing a mark
"['           Jump to start of prev line containing a mark
"`]           Jump by alphabetical order to next mark
"`[           Jump by alphabetical order to prev mark
"']           Jump by alphabetical order to start of next line having a mark
"'[           Jump by alphabetical order to start of prev line having a mark
"m/           Open location list and display marks from current buffer

"m[0-9]       Toggle the corresponding marker !@#$%^&*()
"m<S-[0-9]>   Remove all markers of the same type
"]-           Jump to next line having a marker of the same type
"[-           Jump to prev line having a marker of the same type
"]=           Jump to next line having a marker of any type
"[=           Jump to prev line having a marker of any type
"m?           Open location list and display markers from current buffer
"m<BS>        Remove all markers
highlight bookmark_color ctermbg=137 ctermfg=235 guibg=grey guifg=RoyalBlue3 
highlight SignatureMarkText guifg=red ctermfg=27
"SlateBlue4: css color name https://www.color-hex.com/color-names.html
highlight SignatureMarkLine guibg=SlateBlue4 ctermbg=27
highlight SignatureMarkerText guifg=green
highlight SignatureMarkerLine guibg=red4 ctermbg=22
autocmd FileType log nmap <silent> <C-N> ]`zz
autocmd FileType log nmap <silent> <C-P> [`zz
autocmd FileType log nmap <silent> <C-M> m.
nmap <silent> ma m.

"dominikduda/vim_current_word {{{2
let g:vim_current_word#highlight_delay = 200
hi CurrentWord guibg=#474e52
hi CurrentWordTwins guibg=#474e52
let g:vim_current_word#included_filetypes = ['log']
"kyazdani42/nvim-tree.lua {{{2
if !empty(glob($HOME."/.vim/plugged/nvim-tree.lua"))
lua << EOF
require'nvim-tree'.setup {
    git = {
        ignore = false,
    },
}
EOF
    nmap <leader>ne :NvimTreeToggle<cr> 
    nmap <leader>nf :NvimTreeFindFile<cr> 
endif

"weirongxu/plantuml-previewer.vim {{{2
au FileType plantuml let g:plantuml_previewer#plantuml_jar_path = get(
    \  matchlist(system('cat `which plantuml` | grep plantuml.jar'), '\v.*\s[''"]?(\S+plantuml\.jar).*'),
    \  1,
    \  0
    \)

"nvim-treesitter/nvim-treesitter {{{2
if !empty(glob($HOME."/.vim/plugged/nvim-treesitter"))
lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = {"lua", "vim", "vimdoc", "query", "go", "bash"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "cpp"},
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    -- disable = function(lang, buf)
    --    local max_filesize = 500 * 1024 -- 100 KB
    --    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --    if ok and stats and stats.size > max_filesize then
    --        return true
    --    end
    -- end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
nmap <silent><leader>cg :TSHighlightCapturesUnderCursor<CR>
endif
