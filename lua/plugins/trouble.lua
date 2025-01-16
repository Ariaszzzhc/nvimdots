local M = {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
    { "<leader>cs", "<cmd>Trouble symbols toggle<cr>",                  desc = "Symbols" },
    { "<leader>cS", "<cmd>Trouble lsp toggle<cr>",                      desc = "LSP references/definitions/..." },
    { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location List" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix List" },
    {
      "[q",
      function()
        if require("trouble").is_open() then
          require("trouble").prev({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Previous Trouble/Quickfix Item",
    },
    {
      "]q",
      function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Next Trouble/Quickfix Item",
    },
  }
}

function M.config()
  local trouble = require("trouble.config")

  local icons = require("configs.icons")

  trouble.setup({
    auto_close = false,
    auto_open = false,
    auto_preview = true,
    auto_refresh = true,
    auto_jump = false,
    warn_no_results = false,
    open_no_results = true,

    modes = {
      diagnostics = {
        desc = "Diagnostics",
        win = {
          position = "right",
        },
      },
      symbols = {
        desc = "Outline",
        win = {
          position = "left",
        },
      },
    },

    icons = {
      kinds = icons.kind,
    },
  })
end

return M
