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
        -- Show "<selected position> / <matches>" instead of the default
        -- "<matches> / <total>", which never changes while moving the selection.
        get_status_text = function(picker, status_opts)
          local showing = (picker.stats.processed or 0) - (picker.stats.filtered or 0)
          local icon = (status_opts and not status_opts.completed) and "* " or ""
          if showing == 0 then
            return icon
          end
          local text = string.format("%s%d / %d", icon, picker:get_index(picker:get_selection_row()), showing)
          local multi = #picker:get_multi_selection()
          if multi > 0 then
            text = string.format("%s (%d selected)", text, multi)
          end
          -- Hide the counter when a long prompt would run into it.
          local cursor_col = vim.api.nvim_win_get_cursor(picker.prompt_win)[2]
          if cursor_col + #text >= vim.api.nvim_win_get_width(picker.prompt_win) then
            return ""
          end
          return text
        end,
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

    -- Telescope only redraws the status counter when results change, so
    -- refresh it after every selection change to keep the position current.
    -- (actions' :enhance() can't be used: hooks are cleared on each new picker.)
    local Picker = require("telescope.pickers")._Picker
    local set_selection = Picker.set_selection
    Picker.set_selection = function(self, row)
      set_selection(self, row)
      if self.prompt_win and self.prompt_bufnr then
        self:get_status_updater(self.prompt_win, self.prompt_bufnr)()
      end
    end
  end,
}
