-- Basic Options
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
