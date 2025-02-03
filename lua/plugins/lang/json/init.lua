local M = {
  setup = function()
    local utils = require("utils")
    local has_lsp, lsp = pcall(require, "lspconfig")

    if has_lsp then
      lsp.jsonls.setup({
        settiongs = {
          json = {
            schemas = require("schemastore").json.schemas(),
          },
        },
        capabilities = utils.lsp_capabilities,
      })
    end
  end,
}

return M
