local M = {
  "folke/which-key.nvim",
}

function M.config()
  local which_key = require("which-key")
  which_key.setup({
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = false,
        nav = false,
        z = false,
        g = false,
      },
    },
    win = {
      border = "rounded",
      padding = {
        2,
        2,
        2,
        2,
      },
    },
    -- ignore_missing = true,
    show_help = false,
    show_keys = false,
    disable = {
      buftypes = {},
      filetypes = { "TelescopePrompt" },
    },
  })

  which_key.add({
    { "<leader>q", "<cmd>confirm q<CR>",  desc = "Quit" },
    { "<leader>h", "<cmd>nohlsearch<CR>", desc = "NOHL" },
    { "<leader>v", "<cmd>vsplit<CR>",     desc = "Split" },
    { "<leader>d", group = "Debug" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>l", group = "LSP" },
    { "<leader>p", group = "Plugins" },
    { "<leader>T", group = "Test" },
    { "<leader>a", group = "Copilot" },
  })
end

return M
