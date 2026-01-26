return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
      end,
      desc = "Format the current buffer",
    },
  },
  opts = {
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "deno_fmt", "biome", "prettier" },
      javascriptreact = { "deno_fmt", "biome", "prettier" },
      typescript = { "deno_fmt", "biome", "prettier" },
      typescriptreact = { "deno_fmt", "biome", "prettier" },
      json = { "deno_fmt", "biome", "prettier" },
      yaml = { "deno_fmt", "biome", "prettier" },
      html = { "deno_fmt", "biome", "prettier" },
      css = { "deno_fmt", "biome", "prettier" },
    },
    stop_after_first = true,
    formatters = {
      deno_fmt = {
        condition = function(ctx)
          local found = vim.fs.find({ "deno.json", "deno.jsonc" }, {
            path = ctx.dirname,
            upward = true,
          })

          return #found > 0
        end,
      },
      biome = {
        condition = function(ctx)
          local found = vim.fs.find({ "biome.json", "biome.jsonc" }, {
            path = ctx.dirname,
            upward = true,
          })

          return #found > 0
        end,
      },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
  },
}
