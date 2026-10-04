-- terraform-ls does NOT read `settings` (it ignores
-- workspace/didChangeConfiguration). Options have to be passed as
-- init_options on the LSP initialize call instead -- see
-- https://github.com/hashicorp/terraform-ls/blob/main/docs/SETTINGS.md
--
-- nvim-lspconfig's default config already enables codelens on attach and
-- sets filetypes to { terraform, terraform-vars }, so neither is repeated here.
return {
  init_options = {
    experimentalFeatures = {
      -- Run `terraform validate` on save for real provider/schema errors,
      -- not just syntax.
      validateOnSave = true,
      -- Completing a resource block fills in its required arguments.
      prefillRequiredFields = true,
    },
  },
}
