return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "json" },
    },
  },
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = function()
          return {
            settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
              },
            },
          }
        end,
      },
    },
  },
}
