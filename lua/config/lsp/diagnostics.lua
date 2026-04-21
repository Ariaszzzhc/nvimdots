local icons = require("config.icons")

vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_lines = {
    current_line = true,
    format = function(diagnostic)
      for d, icon in pairs(icons.diagnostics) do
        if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
          return icon .. " " .. diagnostic.message
        end
      end

      if diagnostic.code ~= nil then
        return "" .. diagnostic.code .. ": " .. diagnostic.message
      end

      return diagnostic.message
    end,
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
    },
  },
})
