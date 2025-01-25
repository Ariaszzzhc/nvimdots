local M = {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    {
      "MunifTanjim/nui.nvim",
      lazy = true,
    },
  },
}

function M.config()
  if vim.o.filetype == "lazy" then
    vim.cmd([[messages clear]])
  end

  local views = require("noice.config.views").defaults

  views.confirm.border.style = "single"
  views.notify.backend = "snacks"

  require("noice").setup({
    cmdline = {
      enabled = true,
      view = "cmdline",
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
    presets = {
      bottom_search = true,
      long_message_to_split = true,
    },
  })
end

return M
