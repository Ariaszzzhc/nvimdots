local status, schemastore = pcall(require, "schemastore")

return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  init_options = {
    provideFormatter = true,
  },
  settings = status and {
    json = {
      schemas = schemastore.json.schemas(),
      validate = { enable = true },
    },
  } or {},
}
