local M = {
  "nvim-lualine/lualine.nvim",
}

function M.config()
  require("lualine").setup({
    options = {
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      ignore_focus = { "NvimTree" },
      theme = "tokyonight-night",
    },
    sections = {
      lualine_a = {},
      lualine_b = { "branch" },
      lualine_c = { "diagnostics" },
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
