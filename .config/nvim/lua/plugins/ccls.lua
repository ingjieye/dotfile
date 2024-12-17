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
