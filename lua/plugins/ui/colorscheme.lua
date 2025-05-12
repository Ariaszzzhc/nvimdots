local M = {
  {
    "folke/tokyonight.nvim",
    cond = not vim.g.vscode,
    lazy = false,
    opts = {
      style = "night",
      transparent = false,
      -- styles = {
      --   sidebars = "transparent",
      --   floats = "transparent",
      -- },
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
        transparent = true,
        italic = false,
      },
    },
  },
  {
    "2nthony/vitesse.nvim",
    dependencies = {
      "tjdevries/colorbuddy.nvim",
    },
    opts = {
      transparent_background = true,
      transparent_float_background = true,
    },
  },
}

return M
