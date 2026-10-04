return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      -- Native fzf sorter; needs a C compiler (gcc is present on this machine).
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Grep" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
    { "<leader>fr", "<cmd>Telescope resume<CR>", desc = "Resume last picker" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
    { "<leader><leader>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
  },
  opts = function()
    local actions = require("telescope.actions")
    return {
      defaults = {
        path_display = { "truncate" },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--glob=!**/.git/*",
        },
        file_ignore_patterns = { "%.git/", "node_modules/", "target/", "_build/", "deps/" },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<Esc>"] = actions.close, -- close straight from insert mode
          },
        },
      },
      pickers = {},
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    pcall(telescope.load_extension, "fzf")
  end,
}
