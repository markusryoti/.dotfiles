local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  callback = function(ev)
    -- Skip special buffers (LSP hover floats, Telescope, neo-tree, quickfix,
    -- terminals). Nothing there needs this: the hover float is a `nofile`
    -- scratch buffer that Neovim already starts treesitter on itself, and
    -- `:help` is handled by the runtime's own ftplugin/help.lua.
    if vim.bo[ev.buf].buftype ~= "" then
      return
    end

    local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
    if not lang then
      return
    end
    -- get_lang() falls back to returning the filetype itself, so plugin
    -- buffers (TelescopePrompt, neo-tree, lazy, ...) reach this point with a
    -- language that has no parser. language.add() reports that by returning
    -- false rather than erroring, so both results have to be checked --
    -- otherwise treesitter.start() throws on every such buffer.
    local ok, added = pcall(vim.treesitter.language.add, lang)
    if not ok or not added then
      return
    end
    if not pcall(vim.treesitter.start, ev.buf, lang) then
      return
    end
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Make LSP hover / signature-help docs stable to scroll.
--
-- $VIMRUNTIME/lua/vim/lsp/util.lua renders those floats as markdown with
-- `conceallevel = 2` but `concealcursor = ''`, and an empty 'concealcursor'
-- means the cursor's line is never concealed -- so whichever line you are on
-- snaps back to raw `**bold**` and ``` fences while every other line stays
-- rendered. Worse, the same function sizes the window from the *concealed*
-- text height, so revealing a line overflows the float and the content jumps.
--
-- Neovim sets 'concealcursor' just before it sets filetype=markdown, so this
-- autocmd runs afterwards and the override wins. The `relative ~= ""` check
-- restricts it to floating windows, leaving real markdown files alone.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "markdown",
  callback = function(ev)
    for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
      if vim.api.nvim_win_get_config(win).relative ~= "" then
        vim.wo[win].concealcursor = "nc"
      end
    end
  end,
})

local codelens_on_attach_filetypes = { elixir = true }
local inlay_hints_on_attach_filetypes = { elixir = true }

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    if client:supports_method("textDocument/definition") then
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
        buffer = ev.buf,
        desc = "Go to definition",
      })
    end

    if client:supports_method("textDocument/codeLens") then
      if codelens_on_attach_filetypes[vim.bo[ev.buf].filetype] then
        vim.lsp.codelens.enable(true, { bufnr = ev.buf })
      end
      vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, {
        buffer = ev.buf,
        desc = "Run code lens",
      })
      vim.keymap.set("n", "<leader>cL", function()
        vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
      end, { buffer = ev.buf, desc = "Toggle code lens" })
    end

    if client:supports_method("textDocument/inlayHint") then
      if inlay_hints_on_attach_filetypes[vim.bo[ev.buf].filetype] then
        vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
      end
      vim.keymap.set("n", "<leader>ch", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
      end, { buffer = ev.buf, desc = "Toggle inlay hints" })
    end

    -- The command comes from nvim-lspconfig's clangd on_attach.
    if client.name == "clangd" then
      vim.keymap.set("n", "<leader>cs", "<cmd>LspClangdSwitchSourceHeader<CR>", {
        buffer = ev.buf,
        desc = "Switch source/header",
      })
    end
  end,
})

-- Restore the last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
