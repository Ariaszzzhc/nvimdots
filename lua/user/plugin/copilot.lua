local M = {
  "zbirenbaum/copilot-cmp",
  event = { "InsertEnter", "LspAttach" },
  dependencies = {
    "zbirenbaum/copilot.lua"
  }
}

function M.config()
  require("copilot").setup({
    suggestion = {
      enabled = false
    },
    panel = {
      enabled = false
    },
  })

  require("copilot_cmp").setup()

end

return M
