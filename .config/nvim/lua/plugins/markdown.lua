return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  -- Loading on `ft` is what upstream expects: the plugin derives its
  -- `file_types` from this very spec. LSP hover floats get filetype=markdown
  -- set programmatically, which loads the plugin and attaches to that float --
  -- verified, so hover docs render even when no .md file has been opened.
  ft = { "markdown" },
  opts = {
    -- anti_conceal defaults to true, which hides the plugin's added text on
    -- the cursor line. That is the same class of problem as Neovim's own
    -- concealcursor = '' (see lua/config/autocmds.lua): the line under the
    -- cursor renders differently from the rest, so content shifts while
    -- scrolling a hover. Turning it off keeps the view stable.
    anti_conceal = { enabled = false },
  },
}
