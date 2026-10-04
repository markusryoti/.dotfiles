-- LSP wiring.
--
-- Neovim 0.11+ provides vim.lsp.config() / vim.lsp.enable() and auto-discovers
-- per-server config files in ~/.config/nvim/lsp/*.lua. mason-lspconfig v2 calls
-- vim.lsp.enable() for every installed server (automatic_enable defaults to
-- true), so there is no per-server setup() loop here -- server settings live in
-- the lsp/ directory at the root of this config.
--
-- jdtls is the one exception and is not wired up here; see lua/plugins/java.lua
-- and after/ftplugin/java.lua.

return {
  {
    "mason-org/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonUpdate",
      "MasonLog",
    },
    build = ":MasonUpdate",
    opts = {
      ui = { border = "rounded" },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      -- On current versions this is just a library of default server configs
      -- that vim.lsp.config reads; it no longer needs setup() calls.
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
      "b0o/SchemaStore.nvim",
    },
    opts = function()
      local servers = {
        "lua_ls",
        "gopls",
        "clangd",
        "basedpyright",
        "ruff",
        "vtsls",
        "rust_analyzer",
        "elixirls",
        "yamlls",
        "helm_ls",
        "jsonls",
        "terraformls",
      }
      -- Inside the ROS dev container (~/Dev/personal/ros2) only a subset is
      -- installable: Mason has no linux-arm64 clangd (the image ships it via
      -- apt, enabled in config below), and go/java/etc. toolchains are absent.
      if vim.env.NVIM_ROS then
        servers = { "lua_ls", "basedpyright", "ruff", "yamlls", "jsonls" }
        return { ensure_installed = servers, automatic_enable = servers }
      end
      -- Inside the Linux study container (~/Dev/personal/docker-linux) only
      -- C/C++ and Rust toolchains exist; clangd comes from apt (see below).
      if vim.env.NVIM_LINUX_DEV then
        servers = { "lua_ls", "rust_analyzer" }
        return { ensure_installed = servers, automatic_enable = servers }
      end
      return {
        -- jdtls is installed here but deliberately kept out of automatic_enable
        -- below: it needs a separate -data workspace per project, the Lombok
        -- javaagent, and extendedClientCapabilities, so nvim-jdtls starts it
        -- per-buffer from after/ftplugin/java.lua instead. Enabling it here too
        -- would attach a second, less capable client to every Java buffer.
        ensure_installed = vim.list_extend({ "jdtls" }, servers),
        -- Passing a list (rather than leaving this at its default `true`)
        -- matters: `true` enables EVERY server installed in Mason's shared
        -- data dir, including leftovers from other configs. That would attach
        -- pyright alongside basedpyright, ts_ls alongside vtsls, and so on.
        -- An explicit allowlist keeps this config self-contained.
        automatic_enable = servers,
      }
    end,
    config = function(_, opts)
      -- Completion capabilities for every server, in one line.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.diagnostic.config({
        virtual_text = { spacing = 2, source = "if_many" },
        severity_sort = true,
        underline = true,
        update_in_insert = false,
        float = { source = "if_many" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
          },
        },
      })

      require("mason-lspconfig").setup(opts)

      if vim.env.NVIM_ROS or vim.env.NVIM_LINUX_DEV then
        vim.lsp.enable("clangd")
      end
    end,
  },

  {
    -- Teaches lua_ls about the Neovim API while editing this config.
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    -- Provides the `helm` filetype. Preferred over towolf/vim-helm, which
    -- upstream helm-ls flags for conflicting with yaml-language-server.
    "qvalentin/helm-ls.nvim",
    ft = "helm",
    opts = {},
  },
}
