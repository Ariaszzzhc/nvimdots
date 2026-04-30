local plugin = require("config.plugin")

plugin.add({
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(opts)
      vim.list_extend(opts, { "zig" })
      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      zls = {},
    },
  },
})
