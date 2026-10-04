-- Note: yamlls' default filetypes are yaml / yaml.docker-compose /
-- yaml.gitlab. Helm templates get the `helm` filetype, so this server never
-- attaches to them -- that is what keeps {{ }} from producing bogus YAML
-- syntax errors. helm_ls delegates to yaml-language-server internally instead.
return {
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      keyOrdering = false, -- alphabetical key ordering is not a real error
      validate = true,
      format = { enable = false }, -- prettier handles formatting via conform
      -- SchemaStore supplies ~1000 schemas (kustomize, GitHub Actions,
      -- docker-compose, ...). Files can also opt in explicitly with a
      -- `# yaml-language-server: $schema=<url>` comment on line 1.
      schemaStore = { enable = false, url = "" },
      schemas = vim.tbl_extend("force", require("schemastore").yaml.schemas(), {
        kubernetes = {
          "k8s/**/*.yaml",
          "k8s/**/*.yml",
          "manifests/**/*.yaml",
          "manifests/**/*.yml",
          "kubernetes/**/*.yaml",
          "*.k8s.yaml",
        },
      }),
    },
  },
}
