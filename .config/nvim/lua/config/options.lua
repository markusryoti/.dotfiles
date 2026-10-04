local o = vim.o

-- Line numbers
o.number = true
o.relativenumber = true
o.signcolumn = "yes" -- always show, so text doesn't shift when diagnostics appear
o.cursorline = true

-- Indentation (2 spaces; see after/ftplugin/ for per-language overrides)
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.smartindent = true

-- Search
o.ignorecase = true
o.smartcase = true -- ...unless the query contains a capital letter
o.inccommand = "split" -- live preview for :s

-- Splits
o.splitright = true
o.splitbelow = true

-- Behaviour
o.clipboard = "unnamedplus" -- share the system clipboard
o.undofile = true -- persistent undo across sessions
o.confirm = true -- prompt instead of failing on unsaved changes
o.updatetime = 200
-- Neovim's default. Do not lower this: Neovim maps grn/gra/grr/gri/grt/grx, so
-- a shorter timeout makes it easy to hesitate mid-sequence, drop out of the
-- mapping, and land on built-in `gr` (virtual-replace) instead. which-key has
-- its own popup delay (200ms), so this does not make the UI feel sluggish.
o.timeoutlen = 1000
o.scrolloff = 8
o.wrap = false
o.mouse = "a"

-- UI
o.termguicolors = true
o.winborder = "rounded" -- Neovim 0.11+: borders every float, no per-plugin config
o.showmode = false -- the statusline already shows it
o.laststatus = 3 -- single global statusline
