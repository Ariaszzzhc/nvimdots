local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
}

function M.config()
  local snacks = require("snacks")
  snacks.setup({
    notifier = {
      enabled = true,
    },
    lazygit = {
      enabled = true,
    },
    indent = {
      enabled = true,
    },
    toggle = {
      enabled = true,
    },
    rename = {
      enabled = true,
    },
    words = {
      enabled = true,
    }
  })
end

return M
