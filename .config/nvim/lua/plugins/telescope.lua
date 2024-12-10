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
      treesitter = false,
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
