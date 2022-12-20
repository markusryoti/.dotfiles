local api = require('nvim-tree.api')

vim.keymap.set('n', '<leader>tt', api.tree.toggle, {})


-- disable netrw at the very start of your init.lua (strongly advised)
--vim.g.loaded_netrw = 1
--vim.g.loaded_netrwPlugin = 1

-- empty setup using defaults
--require("nvim-tree").setup()

require("nvim-tree").setup({
    sort_by = "case_sensitive",
    hijack_netrw = false,
    view = {
        adaptive_size = true,
        mappings = {
            list = {
                { key = "u", action = "dir_up" },
            },
        },
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
})
