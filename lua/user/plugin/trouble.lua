local M = {
  "folke/trouble.nvim",
  cmd = "Trouble",
}

function M.config()
  local trouble = require("trouble.config")
  local wk = require("which-key")

  local icons = require("user.ui.icons")

  wk.add({
    { "<leader>lx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics" },
    { "<leader>lo", "<cmd>Trouble symbols toggle<CR>",     desc = "Outline" },
  })

  trouble.setup({
    auto_close = false,
    auto_open = false,
    auto_preview = true,
    auto_refresh = true,
    auto_jump = false,
    warn_no_results = false,
    open_no_results = true,

    modes = {
      diagnostics = {
        desc = "Diagnostics",
        win = {
          position = "right",
        },
      },
      symbols = {
        desc = "Outline",
        win = {
          position = "left",
        },
      },
    },

    icons = {
      kinds = icons.kind,
    },
  })
end

return M
