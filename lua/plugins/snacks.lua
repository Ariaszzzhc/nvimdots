local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  cond = not vim.g.vscode,
}

function M.config()
  local snacks = require("snacks")
  snacks.setup({
    notifier = {
      enabled = true,
    },
    lazygit = {
      enabled = true,
    },
    indent = {
      enabled = true,
    },
    toggle = {
      enabled = true,
    },
    rename = {
      enabled = true,
    },
    words = {
      enabled = true,
    },
    profiler = {
      pick = {
        picker = "fzf-lua",
      },
    },
    input = {
      enabled = true,
      b = {
        completion = false,
      },
    },
    zen = {
      toggles = {
        dim = false,
        mini_diff_signs = true,
      },
      show = {
        statusline = true,
        tabline = false,
      },
    },
    styles = {
      input = {
        border = "single",
      },
      blame_line = {
        border = "single",
      },
      notification = {
        border = "single",
      },
      notification_history = {
        border = "single",
      },
      scratch = {
        border = "single",
      },
    },
  })

  Snacks.toggle({
    name = "Mini Diff Signs",
    get = function()
      return vim.g.minidiff_disable ~= true
    end,
    set = function(state)
      vim.g.minidiff_disable = not state
      if state then
        require("mini.diff").enable(0)
      else
        require("mini.diff").disable(0)
      end
      -- HACK: redraw to update the signs
      vim.defer_fn(function()
        vim.cmd([[redraw!]])
      end, 200)
    end,
  }):map("<leader>uG")

  Snacks.toggle.zen():map("<leader>uz")
end

return M
