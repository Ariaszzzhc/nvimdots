return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "astro" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        astro = {},
      },
    },
  },
}
