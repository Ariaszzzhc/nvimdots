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

  local symbols = trouble.statusline({
    mode = "symbols",
    groups = {},
    title = false,
    filter = { range = true },
    format = "{kind_icon}{symbol.name:Normal}",
    hl_group = "lualine_c_normal",
  })

  require("lualine").setup({
    options = {
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      theme = "tokyonight-night",
      globalstatus = vim.o.laststatus == 3,
      disabled_filetypes = { statusline = { "NvimTree", "ministarter" } },
    },
    sections = {
      lualine_a = {},
      lualine_b = { "branch" },
      lualine_c = { "diagnostics", { symbols and symbols.get } },
      lualine_x = {
        function()
          local icons = require("user.ui.icons")
          local copilot_on = vim.g.copilot_on
          if copilot_on then
            return icons.misc.Copilot
          else
            return icons.misc.CopilotOff
          end
        end,
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = {},
    },
    extensions = { "quickfix", "man", "fugitive" },
  })
end

return M
