local M = {
  "github/copilot.vim",
  cmd = "Copilot",
  event = "InsertEnter",
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpMenuOpen",
      callback = function()
        vim.cmd([[call copilot#Dismiss() ]])
      end,
    })
  end
}

function M.config()
  vim.g.copilot_on = true
  local wk = require("which-key")

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
end

return M
