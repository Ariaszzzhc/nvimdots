local plugin = require("config.plugin")

plugin.add({
  "nvim-treesitter/nvim-treesitter",
  opts = function(opts)
    vim.list_extend(opts, { "c", "cpp", "cmake" })
    return opts
  end,
}, {
  "neovim/nvim-lspconfig",
  opts = {
    clangd = {},
  },
}, {
  "Civitasv/cmake-tools.nvim",
  ft = { "c", "cpp", "cmake" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {},
}, {
  "p00f/clangd_extensions.nvim",
  ft = { "c", "cpp" },
  opts = {},
})
