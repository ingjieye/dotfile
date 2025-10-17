------ Bootstrap lazy options {{{1
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
------ Basic Options {{{1
vim.opt.rtp:prepend(lazypath)
vim.opt.cmdheight = 2
vim.opt.backspace = "indent,eol,start"
vim.opt.termguicolors = true -- 开启真彩色
vim.opt.foldmethod = "marker"
vim.opt.cindent = true -- 设置C样式的缩进格式
vim.opt.tabstop = 4 -- 设置tab长度
vim.opt.shiftwidth = 4 -- 同上
vim.opt.expandtab = true
vim.opt.hlsearch = true -- 高亮搜索
vim.opt.incsearch = true -- 实时搜索
vim.opt.ignorecase = true -- 忽略大小写
vim.opt.cursorline = true -- 高亮光标所在行
vim.opt.number = true -- 显示行号
vim.opt.mouse = "a" -- 永远使用鼠标
vim.opt.signcolumn = "yes"
vim.opt.wildmenu = true
vim.opt.scrolloff = 3 -- 显示光标上下文
vim.opt.updatetime = 100 -- Smaller updatetime for CursorHold & CursorHoldI
vim.opt.showbreak = "↪"
vim.opt.breakindent = true
vim.opt.showmode = false
vim.opt.fillchars:append({ eob = " " })
vim.opt.fillchars:append({ eob = " " })

-- Leader key
vim.g.mapleader = "," -- leader键变为逗号

-- ShaDa settings (previously shada in Vim)
vim.opt.shada = "!,'10000,<50,s10,h"

local fn = vim.fn

function _G.qftf(info)
    local items
    local ret = {}
    -- The name of item in list is based on the directory of quickfix window.
    -- Change the directory for quickfix window make the name of item shorter.
    -- It's a good opportunity to change current directory in quickfixtextfunc :)
    --
    -- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
    -- local root = getRootByAlterBufnr(alterBufnr)
    -- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))
    --
    if info.quickfix == 1 then
        items = fn.getqflist({id = info.id, items = 0}).items
    else
        items = fn.getloclist(info.winid, {id = info.id, items = 0}).items
    end
    local limit = 50
    local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
    local validFmt = '%s │%5d:%-3d│%s %s'
    for i = info.start_idx, info.end_idx do
        local e = items[i]
        local fname = ''
        local str
        if e.valid == 1 then
            if e.bufnr > 0 then
                fname = fn.bufname(e.bufnr)
                if fname == '' then
                    fname = '[No Name]'
                else
                    fname = fname:gsub('^' .. vim.env.HOME, '~')
                end
                -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
                if #fname <= limit then
                    fname = fnameFmt1:format(fname)
                else
                    fname = fnameFmt2:format(fname:sub(1 - limit))
                end
            end
            local lnum = e.lnum > 99999 and -1 or e.lnum
            local col = e.col > 999 and -1 or e.col
            local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
            str = validFmt:format(fname, lnum, col, qtype, e.text)
        else
            str = e.text
        end
        table.insert(ret, str)
    end
    return ret
end

vim.o.qftf = '{info -> v:lua._G.qftf(info)}'
------ Plugins {{{1
require("lazy").setup({
  spec = {
    {
        "pappasam/papercolor-theme-slim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme PaperColorSlim]])
        end,
    },
    { "ingjieye/papercolor-theme" },
    { "mhinz/vim-signify" },
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-lualine/lualine.nvim" },
    { "nvim-lua/lsp-status.nvim" },
    { "scrooloose/nerdcommenter" },
    { "christoomey/vim-tmux-navigator" },
    { "junegunn/fzf", build = "./install --all" },
    { "junegunn/fzf.vim" },
    { "r0mai/vim-djinni" },
    { "ranjithshegde/ccls.nvim" },
    { "mtdl9/vim-log-highlighting" },
    { "rhysd/git-messenger.vim" },
    { "tpope/vim-fugitive" },
    { "iamcco/markdown-preview.nvim", build = "cd app && yarn install", ft = { "markdown" } },
    { "godlygeek/tabular" },
    { "plasticboy/vim-markdown" },
    { "keith/swift.vim" },
    { "phaazon/hop.nvim" },
    { "kyazdani42/nvim-web-devicons" },
    { "kyazdani42/nvim-tree.lua" },
    { "aklt/plantuml-syntax" },
    { "tyru/open-browser.vim" },
    { "weirongxu/plantuml-previewer.vim" },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-treesitter/playground" },
    { "nvim-neotest/nvim-nio" },
    { "mfussenegger/nvim-dap" },
    { "rcarriga/nvim-dap-ui" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope.nvim", tag = "0.1.5" },
    { "kevinhwang91/nvim-bqf" },
    { "nvim-neotest/neotest" },
    { "windwp/nvim-autopairs" },
    { "alfaix/neotest-gtest" },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "zbirenbaum/copilot.lua" },
    { "CopilotC-Nvim/CopilotChat.nvim" },
    { "zbirenbaum/copilot-cmp" },
    { "ThePrimeagen/harpoon" },
  }
})
------ Plugin options {{{1
------ ('plugins.cmp') {{{2
local cmp = require('cmp')
cmp.setup {
    preselect = cmp.PreselectMode.None,
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                copilot = "[Copilot]",
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                ultisnips = "[UltiSnips]",
                nvim_lua = "[Lua]",
                cmp_tabnine = "[TabNine]",
                look = "[Look]",
                path = "[Path]",
                spell = "[Spell]",
                calc = "[Calc]",
                emoji = "[Emoji]"
            })[entry.source.name]
            return vim_item
        end
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-l>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<Enter>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        }),
    },
    sources = {
        {name = 'nvim_lsp'},
        {name = "copilot"},
        {name = 'buffer'},
    },
    completion = {completeopt = 'menu,menuone,noselect,noinsert'},
    experimental = {
        ghost_text = false,
    },
}
------ ('plugins.copilot') {{{2
require('copilot').setup({
  panel = {
    enabled = false,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = false,
    auto_trigger = true,
    hide_during_completion = true,
    debounce = 75,
    keymap = {
      accept = "<M-l>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 18.x
  server_opts_overrides = {},
})
------ ('plugins.copilot_chat') {{{2
require("CopilotChat").setup {
    mappings = {
        complete = {
            insert = '<Tab>',
        },
        close = {
            normal = 'q',
            insert = '<C-c>',
        },
        reset = {
            normal = '<C-q>',
            insert = '<C-q>',
        },
        submit_prompt = {
            normal = '<CR>',
            insert = '<C-s>',
        },
        toggle_sticky = {
            detail = 'Makes line under cursor sticky or deletes sticky line.',
            normal = 'gr',
        },
        accept_diff = {
            normal = '<C-y>',
            insert = '<C-y>',
        },
        jump_to_diff = {
            normal = 'gj',
        },
        quickfix_diffs = {
            normal = 'gq',
        },
        yank_diff = {
            normal = 'gy',
            register = '"',
        },
        show_diff = {
            normal = 'gd',
        },
        show_info = {
            normal = 'gi',
        },
        show_context = {
            normal = 'gc',
        },
        show_help = {
            normal = 'gh',
        },
    },
}

------ ('plugins.copilot_cmp') {{{2
require("copilot_cmp").setup()
------ ('plugins.nvim-tree') {{{2
require'nvim-tree'.setup {
    git = {
        ignore = false,
    },
}
------ ('plugins.dap') {{{2
local dap, dapui = require('dap'), require("dapui")
dap.adapters.lldb = {
  type = 'executable',
  command = '/opt/homebrew/opt/llvm@16/bin/lldb-vscode',
  name = 'lldb',
  options = {
      initialize_timeout_sec = 30
  }
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

dapui.setup()

vim.fn.sign_define("DapBreakpoint", { text = "🔴" })
vim.fn.sign_define("DapStopped", { text = "👉" })
------ ('plugins.nvim-bqf') {{{2
local function set_highlight(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

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
        delay_syntax = 50,
        border = 'double',
        show_title = true,
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
        prevhist = 'h', --  cycle to previous quickfix list in quickfix window         
        nexthist = 'l', --  cycle to next quickfix list in quickfix window             
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
------ ('plugins.telescope') {{{2
local actions = require("telescope.actions")
require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        ["<esc>"] = actions.close
      }
    },
    preview = {
      treesitter = true,
    },
    layout_strategy = 'vertical',
  },
  pickers = {
    find_files = {
      previewer = false,
      find_command = {'fd', '--type', 'f', '--hidden', '--follow', '--no-ignore', '--ignore-file', '~/.fd-ignore'},
    },
    live_grep = {
      previewer = true,
    },
    oldfiles = {
      cwd_only = true,
    }
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}
------ ('plugins.nvim-autopairs') {{{2
require("nvim-autopairs").setup {}
------ ('plugins.neotest') {{{2
require("neotest").setup({
    adapters = {
        require("neotest-gtest").setup({
            debug_adapter = "lldb",
        })
    },
    discovery = {
        -- Drastically improve performance in ginormous projects by
        -- only AST-parsing the currently opened buffer.
        enabled = false,
        -- Number of workers to parse files concurrently.
        -- A value of 0 automatically assigns number based on CPU.
        -- Set to 1 if experiencing lag.
        concurrent = 1,
    },
    running = {
        -- Run tests concurrently when an adapter provides multiple commands to run.
        concurrent = true,
    },
    summary = {
        -- Enable/disable animation of icons.
        animated = false,
    },
    icons = {
        passed = "✅",
        running = "⏳",
        failed = "❌",
        skipped = "⏭️",
        unknown = "❓",
    },
    highlights = {
        passed = "@character",
        running = "@bollean",
    }
})
------ ('plugins.lualine') {{{2
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'papercolor',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {
            {
                'filename',
                path = 1
            },
        },
        lualine_c = {
            {'diagnostics'},
            {
                function()
                    return require('lsp-status').status()
                end,
                cond = function()
                    return #vim.lsp.get_clients() > 0
                end,
            },
        },
        lualine_x = {
            {
                function()
                    return vim.b.lsp_current_function or ''
                end,
                cond = function()
                    return #vim.lsp.get_clients() > 0
                end,
            },
        },
        lualine_y = {'progress'},
        lualine_z = {'location'},
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a =
        {
            {
                'tabs',
                max_length = 999,
                mode = 1,
                tabs_color = {
                    active = 'lualine_a_normal',
                    inactive = 'lualine_b_normal'
                },
            },
        },
        lualine_b = {''},
        lualine_c = {''},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {''}
    },
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

-- listen lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = "lualine_augroup",
  pattern = "LspProgressStatusUpdated",
  callback = require("lualine").refresh,
})
------ ('plugins.lsp-status') {{{2
local lsp_status = require('lsp-status')
lsp_status.config({
    diagnostics = false, --The diagnostics is shown in the lualine
    current_function = false, --The current function is shown in the lualine
    indicator_ok = '',
    status_symbol = ''
})

lsp_status.register_progress()
------ ('plugins.signify') {{{2
-- -- Signify settings
vim.g.signify_sign_show_count = 0
vim.g.signify_realtime = 1 -- 实时
vim.g.signify_sign_add = '▊'
vim.g.signify_sign_change = '▊'
vim.g.signify_sign_delete = '▊'
------ ('plugins.nerdcommenter') {{{2
-- NERDCommenter settings
vim.g.NERDCreateDefaultMappings = 0
vim.g.NERDSpaceDelims = 1
vim.g.NERDCommentEmptyLines = 1
vim.g.NERDToggleCheckAllLines = 1
vim.g.NERDDefaultAlign = 'left' 
------ ('plugins.fzf') {{{2
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
------ ('plugins.git-messenger') {{{2
vim.g.git_messenger_date_format = "%Y-%m-%d %X" 
------ ('plugins.markdown') {{{2
vim.g.vim_markdown_folding_disabled = 1 
------ ('plugins.plantuml') {{{2
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'plantuml',
    callback = function()
        local cmd = "cat `which plantuml` | grep plantuml.jar"
        local output = vim.fn.system(cmd)
        local jar_path = vim.fn.matchlist(output, [[\v.*\s['"]?(\S+plantuml\.jar).*]])[2]
        vim.b.plantuml_previewer_plantuml_jar_path = jar_path
    end
}) 
------ ('plugins.hop') {{{2
require('hop').setup() 
------ ('plugins.ccls') {{{2
require("ccls").setup({
    win_config = {
        -- Sidebar configuration
        sidebar = {
            size = 50,
            position = "botright",
            split = "split",
            width = 50,
            height = 20,
        },
        -- floating window configuration. check :help nvim_open_win for options
        float = {
            style = "minimal",
            relative = "cursor",
            width = 50,
            height = 20,
            row = 0,
            col = 0,
            border = "double",
        },
    },
})
------ ('plugins.nvim-treesitter') {{{2
require'nvim-treesitter.configs'.setup {

  ensure_installed = {"lua", "vim", "vimdoc", "query", "go", "bash", "c", "cpp"},

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
    -- disable = { "c", "cpp"},
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        return false
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
------ LSP Options {{{1
------ ccls options {{{2
local ccls_options =
{
    on_init = function(client, _)
        client.server_capabilities.semanticTokensProvider = nil
    end,
    init_options = {
        cmd = {'ccls'},
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
        index = {
            threads = 4,
            initialBlacklist = {".cmake", "/jni/", "DerivedData"},
        },
        diagnostic = {
            onChange = 0,
        },
        completion = {
            caseSensitivity = 1,
        },
        cache = {
            retainInMemory = 0,
        },
        highlight = {
            rainbow = 10,
        },
    }
}
------ lua_ls options {{{2
local lua_ls_options =
{
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                -- library = vim.api.nvim_get_runtime_file("", true)
            }
        })
    end,
    settings = {
        Lua = {
            diagnostics = {
                disable = { 'trailing-space', 'unused-local', 'unused-function' }
            },
        }
    }
}
------ on_attach {{{2
local on_attach = function(client, bufnr)

    local function map(mode, lhs, rhs, opts)
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

    local function nmap(lhs, rhs, opts)
        map('n', lhs, rhs, opts)
    end

    local function buf_set_option(name, value) vim.api.nvim_set_option_value(name, value, {scope='local'}) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- Jump to Definitions
    nmap('gd', '<cmd>Telescope lsp_definitions<cr>', 'Definitions')
    nmap('<leader>gd', "<cmd>lua require('telescope.builtin').lsp_definitions({ jump_type='vsplit' })<cr>", 'Definitions')
    nmap('<leader>gt', "<cmd>lua require('telescope.builtin').lsp_definitions({ jump_type='tab' })<cr>", 'Definitions')
    nmap('gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', 'Declarations')

    local function custom_references()
        local params = vim.lsp.util.make_position_params()
        params.context = {
            includeDeclaration = false,
        }
        vim.lsp.buf_request(0, 'textDocument/references', params, function(err, result, ctx, config)
            if err or not result or vim.tbl_isempty(result) then
                return
            end
            if #result == 1 then
                vim.lsp.util.jump_to_location(result[1], client.offset_encoding)
            else
                vim.lsp.handlers['textDocument/references'](err, result, ctx, config)
            end
        end)
    end

    -- Jump to references
    -- nmap('gr', '<cmd>lua vim.lsp.buf.references({ includeDeclaration = false })<CR>', 'References')
    nmap('gr', custom_references, { desc = 'References' })
    nmap(',f', '<cmd>lua require("ccls.protocol").request("textDocument/references",{excludeRole=32})<cr>') -- not call
    nmap(',m', '<cmd>lua require("ccls.protocol").request("textDocument/references",{role=64})<cr>')        -- macro
    nmap(',r', '<cmd>lua require("ccls.protocol").request("textDocument/references",{role=8})<cr>')         -- read
    nmap(',w', '<cmd>lua require("ccls.protocol").request("textDocument/references",{role=16})<cr>')        -- write

    -- Jump to type definition
    nmap('gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', 'Type definition')

    -- Action
    nmap('<leader>qf', '<cmd>lua vim.lsp.buf.code_action()<cr>') -- show code action (quick fix)
    nmap('<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename') -- rename
    nmap('<space>=', '<cmd>lua vim.lsp.buf.formatting()<cr>') --format
    map('v', '<leader>cf', '<cmd>lua vim.lsp.buf.format()<CR><Esc>', {silent = false}) --format
    function _G.format_current_line()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        vim.lsp.buf.format({
            range = {
                start = {line - 1, 0},
                ["end"] = {line, 0},
            },
        })
    end

    nmap('<leader>cf', '<cmd>lua format_current_line()<CR>', { desc = 'Format current line' })

    -- Documentation
    nmap('K', '<cmd>lua vim.lsp.buf.hover()<cr>', 'Hover')                                    -- show information about the code under the cursor
    nmap('<space>li', '<cmd>Inspect<cr>')                                                     -- Show inspect for current word
    nmap('<space>o', '<cmd>Telescope lsp_document_symbols<cr>')                               -- Show symbol for corrent document
    nmap('<space>s', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', 'Workspace symbols') --show symbol for current workspace

    -- Cross reference
    nmap('xB', '<cmd>CclsBaseHierarchy float<cr>')
    nmap('xC', '<cmd>CclsOutgoingCalls<cr>', 'callee')
    nmap('xD', '<cmd>CclsDerivedHierarchy float<cr>')
    nmap('xM', '<cmd>CclsMemberHierarchy float<cr>', 'member')
    nmap('xb', '<cmd>CclsBaseHierarchy float<cr>')
    nmap('xc', '<cmd>CclsIncomingCallsHierarchy float<cr>', 'caller')
    nmap('xd', '<cmd>CclsDerived<cr>')
    nmap('xi', '<cmd>lua vim.lsp.buf.implementation()<cr>', 'Implementation')
    nmap('xm', '<cmd>CclsMember<cr>', 'member')
    nmap('xn', function() M.lsp.words.jump(vim.v.count1) end, 'Next reference')
    nmap('xp', function() M.lsp.words.jump(-vim.v.count1) end, 'Prev reference')
    nmap('xv', '<cmd>CclsVars<cr>', 'vars')

    -- Unknown..
    nmap('<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>')
    map('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')

    nmap('<space>ls', function() require'my.util'.switch_source_header(0) end, 'Switch source and header')
    nmap('[e', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    nmap(']e', '<cmd>lua vim.diagnostic.goto_next()<cr>')

    -- Support code codeLens
    -- if client.supports_method 'textDocument/codeLens' then
    --     vim.api.nvim_create_autocmd({'BufEnter'}, {
    --         group = vim.api.nvim_create_augroup('lsp_buf_' .. bufnr, {clear = true}),
    --         buffer = bufnr,
    --         callback = function(ev)
    --             vim.lsp.codelens.refresh({bufnr = 0})
    --         end,
    --     })
    --     vim.lsp.codelens.refresh({bufnr = 0})
    -- end

    -- Support highlight current word
    if client.supports_method 'textDocument/documentHighlight' then
        vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI', 'CursorMoved', 'CursorMovedI'}, {
            group = vim.api.nvim_create_augroup('lsp_word_' .. bufnr, {clear = true}),
            buffer = bufnr,
            callback = function(ev)
                if ev.event:find('CursorMoved') then
                    vim.lsp.buf.clear_references()
                else
                    vim.lsp.buf.document_highlight()
                end

                require('lsp-status').update_current_function()
            end,
            desc = 'Document Highlight',
        })
    end

    -- Support show current function name
    if client.supports_method 'textDocument/documentSymbol' then
        vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI', 'CursorMoved', 'CursorMovedI'}, {
            group = vim.api.nvim_create_augroup('lsp_current_function_' .. bufnr, {clear = true}),
            buffer = bufnr,
            callback = function()
                require('lsp-status').update_current_function()
            end,
            desc = 'Current function',
        })
    end

end

------ lspconfig {{{2
local global_lsp_options =
{
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    }
}

local lsp_options = {
    ccls = ccls_options,
    lua_ls = lua_ls_options,
}

local servers = {'ccls', 'lua_ls', 'gopls'}
local nvim_lsp = require('lspconfig')
for _, lsp in ipairs(servers) do
    local lsp_option = lsp_options[lsp] or {}
    local merged_option = vim.tbl_extend('force', global_lsp_options, lsp_option)
    nvim_lsp[lsp].setup(merged_option)
end


------ keymappings {{{1
-- Functions for key mapping {{{2
local function map(mode, lhs, rhs, opts)
    local options = { silent = true }
    if opts then
        if type(opts) == 'string' then
            opts = {desc = opts}
        end
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Helper function for normal mode mapping
local function nmap(lhs, rhs, opts)
    map('n', lhs, rhs, opts)
end

-- Helper function for terminal mode mapping
local function tmap(lhs, rhs, opts)
    map('t', lhs, rhs, opts)
end

-- Legacy normal mode mapping function using nvim_set_keymap
local function nmapp(lhs, rhs, opts)
    local options = {}
    if opts then
        if type(opts) == 'string' then
            opts = {desc = opts}
        end
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap('n', lhs, rhs, options)
end

local function isQuickFixOpen()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            return true
        end
    end
    return false
end

-- Toggle quickfix window function
local function ToggleQuickFix()
    if isQuickFixOpen() then
        vim.cmd "cclose"
    else
        vim.cmd "copen"
    end
end

-- Leader {{{2

-- Harpoon mappings for quick file navigation
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

nmap("<leader>ha", mark.add_file)
nmap("<leader>he", ui.toggle_quick_menu)
nmap("<leader>1", function() ui.nav_file(1) end, 'Harpoon 1')
nmap("<leader>2", function() ui.nav_file(2) end, 'Harpoon 2')
nmap("<leader>3", function() ui.nav_file(3) end, 'Harpoon 3')
nmap("<leader>4", function() ui.nav_file(4) end, 'Harpoon 4')
nmap("<leader>5", function() ui.nav_file(5) end, 'Harpoon 5')
nmap("<leader>6", function() ui.nav_file(6) end, 'Harpoon 6')

-- General utility mappings
nmap("<leader>cc", "<Plug>NERDCommenterToggle", "Toggle comment")
map("v", "<leader>cc", "<Plug>NERDCommenterToggle", "Toggle comment")

-- quickfix mappings
nmap("<leader>qt", function() ToggleQuickFix() end, "Toggle quickfix window")

nmap("<leader>ne", ":NvimTreeToggle<CR>", "Toggle NvimTree") 
nmap("<leader>nf", ":NvimTreeFindFile<CR>", "Find file in NvimTree")
nmap("<leader>cg", ":TSHighlightCapturesUnderCursor<CR>", "Show treesitter captures")

-- Debug Adapter Protocol (DAP) mappings
nmap("<leader>dk", function() require'dap'.step_out() end, "Step out")
nmap("<leader>dl", function() require'dap'.step_into() end, "Step into")
nmap("<leader>dj", function() require'dap'.step_over() end, "Step over")
nmap("<leader>dc", function() require'dap'.continue() end, "Continue")
nmap("<leader>db", function() require'dap'.toggle_breakpoint() end, "Toggle breakpoint")
nmap("<leader>d_", function() require'dap'.run_last() end, "Run last")
nmap("<leader>ds", function() require'dap'.terminate() end, "Terminate")
nmap("<leader>du", function() require'dapui'.toggle() end, "Toggle DAP UI")
nmap("<leader>dr", function() require'neotest'.run.run({strategy = "dap"}) end, "Run tests with DAP")

-- Telescope fuzzy finder mappings
nmap("<leader>ff", ":Telescope<CR>", "Open Telescope")
nmap("<leader>fg", ":Telescope live_grep<CR>", "Telescope live grep")
nmap("<leader>fb", ":Telescope buffers<CR>", "Telescope buffers")

-- Direct key mappings without prefix {{{2
nmap("=", ":exe \"resize \" . (winheight(0) * 3/2)<CR>", "Increase window height")
nmap("-", ":exe \"resize \" . (winheight(0) * 2/3)<CR>", "Decrease window height")
nmap("+", ":exe \"vertical resize \" . (winwidth(0) * 4/3)<CR>", "Increase window width")
nmap("_", ":exe \"vertical resize \" . (winwidth(0) * 3/4)<CR>", "Decrease window width")
nmap("H", ":noh<CR>", "Clear search highlight")
nmap("s", ":HopChar2<CR>", "Hop to character")
-- Map 'q' to close quickfix window if it's open, otherwise act as normal 'q'
nmap('q', function()
    -- check if there's any quickfix window
    if isQuickFixOpen() then
        return ':cclose<cr>'
    end
    return 'q'
end, { expr = true, silent = true, desc = "close quickfix window if open, otherwise normal 'q'" })

-- Alt/Meta {{{2
nmap("<M-1>", ":tabnext 1<CR>", "Go to tab 1")
nmap("<M-2>", ":tabnext 2<CR>", "Go to tab 2")
nmap("<M-3>", ":tabnext 3<CR>", "Go to tab 3")
nmap("<M-4>", ":tabnext 4<CR>", "Go to tab 4")
nmap("<M-5>", ":tabnext 5<CR>", "Go to tab 5")

-- Ctrl {{{2
map("n", "<C-S>", ":update<CR>", "Save file")
map("v", "<C-S>", "<C-C>:update<CR>", "Save file")
map("i", "<C-S>", "<Esc>:update<CR>", "Save file")
nmap("<C-F>", ":FZF<CR>", "Open FZF")

-- Map <C-P> and <C-N> to Jump between coc diagnostics and quickfix, if no quickfix, then jump between lsp diagnostics
local function CtrlN()
    if isQuickFixOpen() then
        vim.cmd('cnext')
    else
        vim.diagnostic.goto_next()
    end
end
local function CtrlP()
    if isQuickFixOpen() then
        vim.cmd('cprev')
    else
        vim.diagnostic.goto_prev()
    end
end

nmap("<C-N>", CtrlN, "Next quickfix")
nmap("<C-P>", CtrlP, "Previous quickfix")
-- <cmd>lua vim.diagnostic.goto_prev()<cr>

-- Space {{{2
vim.keymap.set("n", "<space>cc", function() require("CopilotChat").open() end, { desc = "Open Copilot Chat" })
vim.keymap.set("v", "<space>cc", function() require("CopilotChat").open() end, { desc = "Open Copilot Chat" })
