return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next git hunk")

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Previous git hunk")

      map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
      -- Capital R deliberately: reset_hunk silently discards your edits, and on
      -- <leader>gr it sat one stray Space away from Neovim's `gra` (code
      -- action). Leaving <leader>gr unmapped makes that slip a no-op.
      map("n", "<leader>gR", gs.reset_hunk, "Reset hunk")
      map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
      map("n", "<leader>gb", function()
        gs.blame_line({ full = true })
      end, "Blame line")
      map("n", "<leader>gd", gs.diffthis, "Diff this")
    end,
  },
}
