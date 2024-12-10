local M = {
  "folke/zen-mode.nvim",
}

function M.config()
  local wk = require("which-key")

  wk.add {
    { "<leader>z", "<cmd>ZenMode<CR>", desc = "ZenMode" },
  }

end

return M
