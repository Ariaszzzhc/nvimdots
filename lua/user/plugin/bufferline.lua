local M = {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  config = function(_, opts)
    require("bufferline").setup(opts)

    vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      offsets = {
        {
          filetype = "NvimTree",
          highlight = "Directory",
          text_align = "left",
        },
      },
      diagnostics_indicator = function(_, _, diag)
        local icons = require("user.ui.icons").diagnostics

        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warning .. diag.warning or "")
        return vim.trim(ret)
      end,
    },
  },
}

return M
