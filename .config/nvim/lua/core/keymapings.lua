-- Functions for key mapping {{{1
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

-- Toggle quickfix window function
local function ToggleQuickFix()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            qf_exists = true
        end
    end
    if qf_exists == true then
        vim.cmd "cclose"
    else
        vim.cmd "copen"
    end
end

-- Leader key mappings {{{1

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
nmap("<leader>qt", function() ToggleQuickFix() end, "Toggle quickfix window")
nmap("<leader>ne", ":NvimTreeToggle<CR>", "Toggle NvimTree") 
nmap("<leader>nf", ":NvimTreeFindFile<CR>", "Find file in NvimTree")
nmap("<leader>cg", ":TSHighlightCapturesUnderCursor<CR>", "Show treesitter captures")

-- Debug Adapter Protocol (DAP) mappings
nmap("<leader>dk", ":lua require'dap'.step_out()<CR>", "Step out")
nmap("<leader>dl", ":lua require'dap'.step_into()<CR>", "Step into")
nmap("<leader>dj", ":lua require'dap'.step_over()<CR>", "Step over")
nmap("<leader>dc", ":lua require'dap'.continue()<CR>", "Continue")
nmap("<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", "Toggle breakpoint")
nmap("<leader>d_", ":lua require'dap'.run_last()<CR>", "Run last")
nmap("<leader>ds", ":lua require'dap'.terminate()<CR>", "Terminate")
nmap("<leader>du", ":lua require'dapui'.toggle()<CR>", "Toggle DAP UI")

-- Telescope fuzzy finder mappings
nmap("<leader>ff", ":Telescope<CR>", "Open Telescope")
nmap("<leader>fg", ":Telescope live_grep<CR>", "Telescope live grep")
nmap("<leader>fb", ":Telescope buffers<CR>", "Telescope buffers")

-- Direct key mappings without prefix {{{1
nmap("=", ":exe \"resize \" . (winheight(0) * 3/2)<CR>", "Increase window height")
nmap("-", ":exe \"resize \" . (winheight(0) * 2/3)<CR>", "Decrease window height")
nmap("+", ":exe \"vertical resize \" . (winwidth(0) * 4/3)<CR>", "Increase window width")
nmap("_", ":exe \"vertical resize \" . (winwidth(0) * 3/4)<CR>", "Decrease window width")
nmap("H", ":noh<CR>", "Clear search highlight")
nmap("s", ":HopChar2<CR>", "Hop to character")

-- Alt/Meta key mappings for tab navigation {{{1
nmap("<M-1>", ":tabnext 1<CR>", "Go to tab 1")
nmap("<M-2>", ":tabnext 2<CR>", "Go to tab 2")
nmap("<M-3>", ":tabnext 3<CR>", "Go to tab 3")
nmap("<M-4>", ":tabnext 4<CR>", "Go to tab 4")
nmap("<M-5>", ":tabnext 5<CR>", "Go to tab 5")

-- Control key mappings {{{1
map("n", "<C-S>", ":update<CR>", "Save file")
map("v", "<C-S>", "<C-C>:update<CR>", "Save file")
map("i", "<C-S>", "<Esc>:update<CR>", "Save file")
nmap("<C-F>", ":FZF<CR>", "Open FZF")

-- Space key mappings {{{1
map("n", "<space>cc", ":CopilotChatOpen<CR>", "Open Copilot Chat")
