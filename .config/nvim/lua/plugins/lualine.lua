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
        lualine_a = {'mode'},
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
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a =
        {
            {
                'tabs',
                max_length = 99,
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
