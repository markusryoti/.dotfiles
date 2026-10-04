-- ruff and basedpyright both attach to Python buffers. Let basedpyright own
-- hover so you don't get two competing popups; ruff keeps lint + code actions.
return {
  on_attach = function(client, _)
    client.server_capabilities.hoverProvider = false
  end,
}
