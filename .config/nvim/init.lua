-- Leader keys must be set before lazy.nvim (and any plugin keymaps) load.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")

-- Inside VSCode (vscode-neovim), VSCode provides LSP, treesitter, pickers and
-- the file tree, so skip lazy.nvim and the LSP/treesitter autocmds entirely.
if vim.g.vscode then
  require("config.vscode")
  return
end

require("config.autocmds")
require("config.lazy")
