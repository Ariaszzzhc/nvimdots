local M = {
  {
    "folke/tokyonight.nvim",
    cond = not vim.g.vscode,
    opts = {
      style = "night",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}

return M
