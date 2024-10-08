local M = {
  "folke/trouble.nvim",
}

function M.config()
  local trouble = require("trouble.config")
  local wk = require("which-key")

  wk.add {
    { "<leader>t", "<cmd>TroubleToggle<CR>", desc = "Trouble" },
  }

  trouble.setup {
    position = "bottom",
    mode = "workspace_diagnostics",
    icons = true,
    severity = nil,
    use_diagnostic_signs = true,
  }
end

return M
