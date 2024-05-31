local M = {
  "zbirenbaum/copilot.lua",
  event = "InsertEnter"
}

function M.config()
  require("copilot").setup({})
end

return M
