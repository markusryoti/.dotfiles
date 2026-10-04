return {
  settings = {
    basedpyright = {
      -- basedpyright defaults to "all", which is extremely noisy on most
      -- real codebases. "standard" matches upstream pyright's behaviour.
      analysis = {
        typeCheckingMode = "standard",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
        },
      },
      -- ruff owns import sorting.
      disableOrganizeImports = true,
    },
  },
}
