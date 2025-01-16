local M = {
  "nvim-lualine/lualine.nvim",
}

function M.init()
  vim.g.lualine_laststatus = vim.o.laststatus
  if vim.fn.argc(-1) > 0 then
    -- set an empty statusline till lualine loads
    vim.o.statusline = " "
  else
    -- hide the statusline on the starter page
    vim.o.laststatus = 0
  end
end

function M.config()
  local trouble = require("trouble")
  local snacks = require("snacks")

  local symbols = trouble.statusline({
    mode = "symbols",
    groups = {},
    title = false,
    filter = { range = true },
    format = "{kind_icon}{symbol.name:Normal}",
    hl_group = "lualine_c_normal",
  })

  local icons = require("configs.icons")

  require("lualine").setup({
    options = {
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      theme = "tokyonight-night",
      globalstatus = vim.o.laststatus == 3,
      disabled_filetypes = { statusline = { "NvimTree", "ministarter" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch",
        {
          "diff",
          symbols = {
            added = icons.git.LineAdded,
            modified = icons.git.LineModified,
            removed = icons.git.LineRemoved,
          },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        }
      },
      lualine_c = { "diagnostics", { symbols and symbols.get, cond = symbols.has } },
      lualine_x = {
        {
          function()
            snacks.profiler.status()
          end,
          cond = snacks.profiler.running,
        },
        {
          function()
            local copilot_on = vim.g.copilot_on
            if copilot_on then
              return icons.misc.Copilot
            else
              return icons.misc.CopilotOff
            end
          end,
        },
        "filetype",
      },
      lualine_y = {
        {
          "progress",
          separator = " ",
          padding = { left = 1, right = 0 },
        },
        {
          "location",
          padding = { left = 0, right = 1 },
        },
      },
      lualine_z = {},
    },
    extensions = { "lazy", "fzf" },
  })
end

return M
