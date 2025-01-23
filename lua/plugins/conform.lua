local M = {
  "stevearc/conform.nvim",
  event = "BufWritePre",
}

function M.config()
  vim.keymap.set("n", "<leader>cf", function()
      require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
    end,
    { desc = "Format the current buffer", noremap = true, silent = true })

  require("conform").setup({
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    },
    default_format_opts = {
      lsp_format = "fallback",
    }
  })
end

return M
