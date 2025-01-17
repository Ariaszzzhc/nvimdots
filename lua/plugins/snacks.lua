local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  cond = not vim.g.vscode,
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
    },
    profiler = {
      pick = {
        picker = "fzf-lua",
      }
    },
    input = {
      enabled = false,
      b = {
        completion = false,
      }
    }
  })
end

return M
