local M = {
  "akinsho/toggleterm.nvim"
}

function M.config()
  local wk = require("which-key")
  local term = require("toggleterm")
  local Terminal = require("toggleterm.terminal").Terminal

  local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

  wk.add {
    "<leader>;", "<cmd>ToggleTerm<CR>", desc = "Term"
  }

  wk.add {
    "<leader>ge", function() lazygit:toggle() end, desc = "LazyGit Window"
  }

  term.setup {
    direction = "float",
  }
end

return M
