return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
      format = { enable = false }, -- stylua handles this via conform
      telemetry = { enable = false },
      hint = { enable = true },
    },
  },
}
