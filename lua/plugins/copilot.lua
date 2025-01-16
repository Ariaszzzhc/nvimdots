local M = {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "InsertEnter",
}

function M.config()
  vim.g.copilot_on = true
  local wk = require("which-key")
  local copilot = require("copilot")

  local opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = true,
      keymap = {
        accept = false,
        next = "<M-]>",
        prev = "<M-[>",
      }
    },
    panel = {
      enabled = false,
    },
    filetypes = {
      markdown = true,
      help = true,
    }
  }

  wk.add({
    "<leader>ae",
    function()
      local copilot_on = vim.g.copilot_on

      if copilot_on then
        vim.g.copilot_on = false
        vim.cmd([[Copilot disable]])
      else
        vim.g.copilot_on = true
        vim.cmd([[Copilot enable]])
      end
    end,
    desc = "Toggle Copilot",
  })

  copilot.setup(opts)
end

return M
