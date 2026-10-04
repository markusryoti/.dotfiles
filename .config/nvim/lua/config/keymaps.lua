local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Keep the cursor centred while jumping around
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Previous search result" })

-- Move selected lines. On <leader> rather than the usual J/K (which would cost
-- visual-J-to-join) or <A-j>/<A-k> (Ghostty leaves macos-option-as-alt off by
-- default, so Option+j emits a character and never reaches Neovim as Alt).
map("v", "<leader>j", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<leader>k", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Stay in indent mode
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Diagnostics
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })

map({ "n", "x" }, "gr", "<Nop>", { desc = "which_key_ignore" })
