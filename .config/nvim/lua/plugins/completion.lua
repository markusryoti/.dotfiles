return {
  "saghen/blink.cmp",
  event = "InsertEnter",
  version = "1.*", -- release tag: ships the prebuilt Rust fuzzy matcher
  opts = {
    -- 'default' keymap:
    --   <C-space> open menu / docs   <C-e> hide   <C-y> accept
    --   <C-n>/<C-p> or <Up>/<Down> select   <Tab>/<S-Tab> snippet jump
    --   <C-k> toggle signature help (overridden below: select_prev when menu is open)

    keymap = {
      preset = "default",
      ["<C-CR>"] = { "accept" },
      -- match telescope: <C-j>/<C-k> move through the menu
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "show_signature", "hide_signature", "fallback" },
    },

    appearance = { nerd_font_variant = "mono" },

    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      ghost_text = { enabled = false },
    },

    signature = { enabled = true },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
