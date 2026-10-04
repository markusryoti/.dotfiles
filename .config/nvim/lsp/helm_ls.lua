return {
  settings = {
    ["helm-ls"] = {
      -- helm-ls shells out to yaml-language-server for schema validation of
      -- the rendered template, rather than letting yamlls attach directly.
      yamlls = {
        enabled = true,
        path = "yaml-language-server",
      },
    },
  },
}
