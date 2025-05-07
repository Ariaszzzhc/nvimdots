local M = {
  "nvim-lualine/lualine.nvim",
  cond = not vim.g.vscode,
}

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
      globalstatus = vim.o.laststatus == 3,
      disabled_filetypes = { statusline = { "ministarter", "snacks_dashboard" }, winbar = { "ministarter" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        "branch",
        {
          "diff",
          symbols = {
            added = icons.git.LineAdded,
            modified = icons.git.LineModified,
            removed = icons.git.LineRemoved,
          },
          source = function()
            local summary = vim.b.minidiff_summary
            return summary
              and {
                added = summary.add,
                modified = summary.change,
                removed = summary.delete,
              }
          end,
        },
      },
      lualine_c = { "diagnostics", { (symbols and symbols.has) and symbols.get or "" } },
      lualine_x = {
        {
          function()
            return snacks.profiler.status()
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
        {
          "fileformat",
          icons_enabled = true,
          symbols = {
            unix = "LF",
            dos = "CRLF",
            mac = "CR",
          },
        },
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
    extensions = { "lazy", "trouble" },
  })
end

return M
