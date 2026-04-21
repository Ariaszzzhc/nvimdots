local plugin = require("config.plugin")

plugin.add({
  "nvim-treesitter/nvim-treesitter",
  opts = function(opts)
    vim.list_extend(opts, { "markdown", "markdown_inline" })
    return opts
  end,
}, {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
  opts = {
    file_types = { "markdown", "opencode_output", "Avante" },
  },
})
