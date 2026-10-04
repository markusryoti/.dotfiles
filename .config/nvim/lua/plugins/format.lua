return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofumpt" },
        python = { "ruff_fix", "ruff_format" },
        rust = { "rustfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        elixir = { "mix" },
        heex = { "mix" },
        eex = { "mix" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        terraform = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" }, -- .tfvars
        hcl = { "terraform_fmt" },
        -- `helm` is deliberately absent: YAML formatters mangle Go templates.
      },
      formatters = {
        clang_format = {
          -- --fallback-style only takes a style name, so check for a
          -- project config ourselves and pass 4-space LLVM when there's none.
          prepend_args = function(_, ctx)
            local found = vim.fs.find({ ".clang-format", "_clang-format" }, { upward = true, path = ctx.dirname })
            if #found > 0 then
              return {}
            end
            return { "--style={BasedOnStyle: LLVM, IndentWidth: 4}" }
          end,
        },
      },
      format_on_save = function(bufnr)
        -- Escape hatch: :lua vim.b.disable_autoformat = true
        if vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then
          return
        end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
    },
    init = function()
      vim.api.nvim_create_user_command("FormatToggle", function(args)
        if args.bang then
          vim.b.disable_autoformat = not vim.b.disable_autoformat
          vim.notify("Buffer autoformat " .. (vim.b.disable_autoformat and "off" or "on"))
        else
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify("Global autoformat " .. (vim.g.disable_autoformat and "off" or "on"))
        end
      end, { bang = true, desc = "Toggle format on save (! = buffer only)" })
    end,
  },

  {
    -- Keeps formatter installs reproducible instead of relying on remembered
    -- :MasonInstall runs. Remove this if you'd rather manage them by hand.
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      -- In the ROS dev container clang-format comes from apt and there is no
      -- Go toolchain, so only install what works there. The Linux study
      -- container (NVIM_LINUX_DEV) has no Node either.
      ensure_installed = vim.env.NVIM_ROS and { "stylua", "prettierd" }
        or vim.env.NVIM_LINUX_DEV and { "stylua" }
        or {
        "stylua",
        "gofumpt",
        "goimports",
        "prettierd",
        "clang-format",
        "yaml-language-server", -- helm_ls shells out to this binary
      },
      run_on_start = true,
      -- rustfmt comes from the Rust toolchain, `mix format` from Elixir.
    },
  },
}
