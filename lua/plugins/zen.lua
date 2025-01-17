local M = {
  "folke/zen-mode.nvim",
  cond = not vim.g.vscode,
  keys = {
    {
      "<leader>uz", "<cmd>ZenMode<CR>", desc = "ZenMode",
    }
  }
}


return M
