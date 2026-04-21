local plugin = require("config.plugin")

plugin.add({
  "nvim-treesitter/nvim-treesitter",
  opts = function(opts)
    vim.list_extend(opts, {
      "css",
      "html",
      "javascript",
      "json",
      "tsx",
      "typescript",
      "yaml",
    })
    return opts
  end,
}, {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "deno_fmt", "biome", "prettier" },
      javascriptreact = { "deno_fmt", "biome", "prettier" },
      typescript = { "deno_fmt", "biome", "prettier" },
      typescriptreact = { "deno_fmt", "biome", "prettier" },
      json = { "deno_fmt", "biome", "prettier" },
      yaml = { "deno_fmt", "biome", "prettier" },
      html = { "deno_fmt", "biome", "prettier" },
      css = { "deno_fmt", "biome", "prettier" },
    },
  },
})
