local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
}

function M.config()
  require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "markdown", "markdown_inline", "bash", "python" },
    highlight = { enable = true },
    indent = { enable = true },
    auto_install = true,
    sync_install = false,
    ignore_install = {},
  }
end

return M
