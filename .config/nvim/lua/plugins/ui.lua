return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer keymaps",
      },
    },
  },

  {
    "echasnovski/mini.statusline",
    version = false,
    event = "VeryLazy",
    opts = { use_icons = true },
  },

  {
    "echasnovski/mini.pairs",
    version = false,
    event = "InsertEnter",
    opts = {},
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = false },
      exclude = {
        filetypes = { "help", "lazy", "mason", "neo-tree", "checkhealth" },
      },
    },
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },
}
