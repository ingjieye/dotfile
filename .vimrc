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

"Plugins {{{1
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
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
Plug 'mfussenegger/nvim-dap' "lldb support in nvim
Plug 'rcarriga/nvim-dap-ui' "lldb support in nvim
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
    " coc extensions
    let g:coc_global_extensions = ['coc-snippets', 'coc-pyright']
    
    "Some servers have issues with backup files, see #649
    set nobackup
    set nowritebackup

    " Smaller updatetime for CursorHold & CursorHoldI
    set updatetime=200

    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

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
    autocmd CursorHold * silent call CocActionAsync('highlight')
    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder.
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Use `:Fold` to fold current buffer
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    let g:coc_snippet_next = '<Tab>'
    let g:coc_snippet_prev = '<S-Tab>'


endif
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

"tagbar设置 {{{2
let g:tagbar_width = 30

"git-messenger {{{2
let g:git_messenger_date_format = "%Y-%m-%d %X"
"vim-ccls {{{2
let g:ccls_size = 10
let g:ccls_position = 'botright'
let g:ccls_orientation = 'horizontal'
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
endif

"mfussenegger/nvim-dap {{{2
if !empty(glob($HOME."/.vim/plugged/nvim-dap"))
lua << EOF

local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/opt/homebrew/opt/llvm/bin/lldb-vscode',
  name = 'lldb'
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}

EOF
endif
"rcarriga/nvim-dap-ui {{{2
if !empty(glob($HOME."/.vim/plugged/nvim-dap-ui"))
lua << EOF

require("dapui").setup()

EOF
endif
"Keybindings{{{1
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

" ----------------- No Prefix ----------------- {{{2
nnoremap <silent> = :exe "resize " . (winheight(0) * 3/2) <cr>
nnoremap <silent> - :exe "resize " . (winheight(0) * 2/3) <cr>
nnoremap <silent> + :exe "vertical resize " . (winwidth(0) * 4/3) <cr>
nnoremap <silent> _ :exe "vertical resize " . (winwidth(0) * 3/4) <cr>
nnoremap <silent> H :noh<Enter>
nnoremap <silent> s :HopChar2<CR>
nnoremap <silent> K :call ShowDocumentation()<CR>
nnoremap <silent> xb :call CocLocations('ccls','$ccls/inheritance')<cr>
nnoremap <silent> xc :CclsCallHierarchy<cr>
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references-used)
nnoremap <silent> xd <Plug>(coc-implementation)
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

" ----------------- Alt(meta/option) ----------------- {{{2
nnoremap <silent> <M-1> :tabnext 1<cr>
nnoremap <silent> <M-2> :tabnext 2<cr>
nnoremap <silent> <M-3> :tabnext 3<cr>
nnoremap <silent> <M-4> :tabnext 4<cr>
nnoremap <silent> <M-5> :tabnext 5<cr>

" ----------------- Ctrl ----------------- {{{2
noremap  <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <Esc>:update<CR>
nnoremap <silent> <C-P> <Plug>(coc-diagnostic-prev)
nnoremap <silent> <C-N> <Plug>(coc-diagnostic-next)
nnoremap <silent> <C-F> :FZF<CR>

if has('nvim')
  inoremap <silent><expr> <C-space> coc#refresh()
else
  inoremap <silent><expr> <C-@> coc#refresh()
endif

autocmd FileType log noremap <silent> <C-N> ]`zz
autocmd FileType log noremap <silent> <C-P> [`zz
autocmd FileType log noremap <silent> <C-M> m.

" ----------------- Leader ----------------- {{{2
nnoremap <leader>rn <Plug>(coc-rename)
nnoremap <leader>f  <Plug>(coc-format-selected)
xnoremap <leader>f  <Plug>(coc-format-selected)
nnoremap <leader>ac <Plug>(coc-codeaction)
nnoremap <leader>qf <Plug>(coc-fix-current)
nnoremap <leader>ne :NvimTreeToggle<cr> 
nnoremap <leader>nf :NvimTreeFindFile<cr> 
nnoremap <silent><leader>cg :TSHighlightCapturesUnderCursor<CR>
nnoremap <silent><leader>gd <C-w>s<Plug>(coc-definition)

" ----------------- Space ----------------- {{{2
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
