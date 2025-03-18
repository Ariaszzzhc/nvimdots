return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "wgsl" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        wgsl_analyzer = {},
      },
    },
  },
}
