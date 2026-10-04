-- Leader keys must be set before lazy.nvim (and any plugin keymaps) load.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
