return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000, -- load before everything else so highlights are set early
  opts = {
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = { light = "latte", dark = "mocha" },
    transparent_background = false,
    integrations = {
      blink_cmp = true,
      gitsigns = true,
      indent_blankline = { enabled = true },
      mason = true,
      mini = { enabled = true },
      native_lsp = { enabled = true },
      neotree = true,
      telescope = { enabled = true },
      treesitter = true,
      which_key = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
