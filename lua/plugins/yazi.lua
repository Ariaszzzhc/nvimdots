local M = {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  cond = not vim.g.vscode,
  keys = {
    {
      "<leader>e",
      mode = { "n", "v" },
      "<cmd>Yazi cwd<CR>",
      desc = "File manager",
    }
  },
}

return M
