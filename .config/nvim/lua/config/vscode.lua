-- Keymaps for running inside VSCode via vscode-neovim (vim.g.vscode is set).
--
-- init.lua loads this instead of lazy.nvim, so no plugins are available here.
-- These mirror the Neovim keys from autocmds.lua (LSP), telescope, neo-tree,
-- gitsigns, conform and nvim-dap, calling the equivalent VSCode commands.
--
-- vscode-neovim does shim vim.lsp.buf.* (so Neovim's default gr* maps half
-- work), but it maps implementation/definition to *peek* and code_action to
-- *source* actions. Explicit maps below give jump-to and quick-fix instead.
--
-- Pickers, the completion menu and debug F-keys live in VSCode's
-- keybindings.json, since Neovim never sees those keys.

local vscode = require("vscode")

local function act(cmd)
  return function()
    vscode.action(cmd)
  end
end

local function map(mode, lhs, cmd, desc)
  local rhs = type(cmd) == "string" and act(cmd) or cmd
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

local nx = { "n", "x" }

-- LSP ------------------------------------------------------------------------
map(nx, "K", "editor.action.showHover", "Hover (again to focus)")
map("n", "gd", "editor.action.revealDefinition", "Go to definition")
map("n", "gD", "editor.action.peekDefinition", "Peek definition")
map("n", "grr", "editor.action.goToReferences", "References")
map("n", "gri", "editor.action.goToImplementation", "Implementation")
map("n", "grt", "editor.action.goToTypeDefinition", "Type definition")
map("n", "grn", "editor.action.rename", "Rename")
map(nx, "gra", "editor.action.quickFix", "Code action")
map("n", "gO", "workbench.action.gotoSymbol", "Document symbols")
map("n", "]d", "editor.action.marker.nextInFiles", "Next diagnostic")
map("n", "[d", "editor.action.marker.prevInFiles", "Previous diagnostic")

-- Diagnostics (overrides the vim.diagnostic maps from keymaps.lua)
map("n", "<leader>d", "editor.action.showHover", "Line diagnostics")
map("n", "<leader>q", "workbench.actions.view.problems", "Problems panel")

-- Code -----------------------------------------------------------------------
map("n", "<leader>cf", "editor.action.formatDocument", "Format buffer")
map("x", "<leader>cf", "editor.action.formatSelection", "Format selection")
map("n", "<leader>cs", "clangd.switchheadersource", "Switch source/header")
map("n", "<leader>ch", function()
  local current = vscode.get_config("editor.inlayHints.enabled")
  local next_value = current == "on" and "offUnlessPressed" or "on"
  vscode.update_config("editor.inlayHints.enabled", next_value, "global")
end, "Toggle inlay hints")

-- Find (telescope) -----------------------------------------------------------
map("n", "<leader>ff", "workbench.action.quickOpen", "Find files")
map("n", "<leader><leader>", "workbench.action.quickOpen", "Find files")
map("n", "<leader>fg", "workbench.action.findInFiles", "Grep")
map("n", "<leader>fb", "workbench.action.showAllEditorsByMostRecentlyUsed", "Buffers")
map("n", "<leader>fd", "workbench.actions.view.problems", "Diagnostics")
map("n", "<leader>fk", "workbench.action.openGlobalKeybindings", "Keymaps")

-- Files / buffers (neo-tree) -------------------------------------------------
map("n", "<leader>e", "workbench.action.toggleSidebarVisibility", "Toggle file tree")
map("n", "<leader>o", "workbench.files.action.focusFilesExplorer", "Focus file tree")
map("n", "<leader>bd", "workbench.action.closeActiveEditor", "Delete buffer")

-- Git (gitsigns) -------------------------------------------------------------
map("n", "]c", "workbench.action.editor.nextChange", "Next git hunk")
map("n", "[c", "workbench.action.editor.previousChange", "Previous git hunk")
map(nx, "<leader>gs", "git.stageSelectedRanges", "Stage hunk")
map(nx, "<leader>gR", "git.revertSelectedRanges", "Reset hunk")
map("n", "<leader>gp", "editor.action.dirtydiff.next", "Preview hunk")
map("n", "<leader>gb", "gitlens.toggleLineBlame", "Blame line")
map("n", "<leader>gd", "git.openChange", "Diff this")

-- Debug (nvim-dap). F-keys are in keybindings.json. -------------------------
map("n", "<leader>Dc", "workbench.action.debug.continue", "Continue / start")
map("n", "<leader>Db", "editor.debug.action.toggleBreakpoint", "Toggle breakpoint")
map("n", "<leader>DB", "editor.debug.action.conditionalBreakpoint", "Conditional breakpoint")
map("n", "<leader>Dl", "editor.debug.action.addLogPoint", "Logpoint")
map("n", "<leader>DC", "editor.debug.action.runToCursor", "Run to cursor")
map("n", "<leader>Dr", "workbench.action.debug.restart", "Restart")
map("n", "<leader>Dt", "workbench.action.debug.stop", "Terminate")
map("n", "<leader>Du", "workbench.view.debug", "Debug view")
map("n", "<leader>De", "editor.debug.action.showDebugHover", "Eval word under cursor")
map("x", "<leader>De", "editor.debug.action.selectionToRepl", "Eval selection in REPL")
map("n", "<leader>DR", "workbench.debug.action.toggleRepl", "Toggle REPL")
