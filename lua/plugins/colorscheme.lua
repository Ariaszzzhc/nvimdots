local M = {
  {
    "folke/tokyonight.nvim",
    cond = not vim.g.vscode,
    lazy = false,
    opts = {
      style = "night",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "scottmckendry/cyberdream.nvim",
    cond = not vim.g.vscode,
    lazy = false,
    opts = {
      transparent = true,
    },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    cond = not vim.g.vscode,
    opts = {
      styles = {
        transparent = true,
        italic = false,
      },
    },
  },
}

return M
