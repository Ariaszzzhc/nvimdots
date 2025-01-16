local M = {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>",           desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",            desc = "Delete Buffers to the Left" },
    { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
    { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
    { "[b",         "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
    { "]b",         "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
    { "[B",         "<cmd>BufferLineMovePrev<cr>",             desc = "Move buffer prev" },
    { "]B",         "<cmd>BufferLineMoveNext<cr>",             desc = "Move buffer next" },
  },
  config = function()
    local buf_delete = require("mini.bufremove")

    local opts = {
      options = {
        close_command = buf_delete.delete,
        show_close_icon = false,
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
          local icons = require("configs.icons").diagnostics

          local ret = (diag.error and icons.Error .. " " .. diag.error .. " " or "")
              .. (diag.warning and icons.Warning .. " " .. diag.warning or "")
          return vim.trim(ret)
        end,
      },
    }

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
