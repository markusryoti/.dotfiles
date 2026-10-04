return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file tree" },
    { "<leader>o", "<cmd>Neotree focus<CR>", desc = "Focus file tree" },
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = "", -- empty string = inherit the global 'winborder'
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true, -- react to changes made outside nvim
      hijack_netrw_behavior = "open_default",
      filtered_items = {
        -- Showing these is less surprising than silently hiding them.
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        never_show = { ".DS_Store", ".git" },
      },
    },
    window = {
      width = 32,
      mappings = {
        ["<space>"] = "none", -- don't shadow the leader key
      },
    },
    default_component_configs = {
      indent = { with_expanders = true },
    },
  },
}
