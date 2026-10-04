-- nvim-jdtls is a library rather than a plugin with a setup() call: the client
-- is started per-buffer from after/ftplugin/java.lua, which is also where all
-- of the jdtls configuration lives. `ft` covers the load, and lazy.nvim's
-- module loader would pull it in on require() even if it did not.
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "mason-org/mason.nvim" },
  },
}
