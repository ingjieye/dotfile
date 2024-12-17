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
Plug 'ThePrimeagen/harpoon'
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
