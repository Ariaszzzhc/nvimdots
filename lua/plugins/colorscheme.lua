local M = {
  {
    "folke/tokyonight.nvim",
    cond = not vim.g.vscode,
    lazy = false,
    opts = {
      style = "night",
      transparent = false,
    },
  },
  {
    "scottmckendry/cyberdream.nvim",
    cond = not vim.g.vscode,
    lazy = false,
    opts = {
      transparent = false,
    },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    cond = not vim.g.vscode,
    opts = {
      styles = {
        transparent = false,
        italic = false,
      },
    },
  },
}

return M
