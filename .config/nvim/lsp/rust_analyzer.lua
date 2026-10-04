return {
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      check = { command = "clippy" },
      inlayHints = {
        parameterHints = { enable = true },
        typeHints = { enable = true },
      },
    },
  },
}
