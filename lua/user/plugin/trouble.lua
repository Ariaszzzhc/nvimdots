local M = {
  "folke/trouble.nvim",
}

function M.config()
  local trouble = require("trouble.config")
  local wk = require("which-key")

  local icons = require("user.ui.icons")

  wk.add {
    { "<leader>x", "<cmd>TroubleToggle<CR>", desc = "Trouble" },
  }

  trouble.setup {
    auto_close = false,
    auto_open = false,
    auto_preview = true,
    auto_refresh = true,
    auto_jump = false,

    icons = {
      kinds = icons.kind,
    }
  }

end

return M
