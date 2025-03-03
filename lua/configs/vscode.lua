local vscode = require("vscode")

local opts = { noremap = true, silent = true }

vim.notify = vscode.notify

-- key mappings

local keymap = vim.keymap.set

-- for source config
keymap("n", "<leader>L", function()
  vscode.action("vscode-neovim.restart")
end, opts)

keymap("n", "<leader>e", function()
  vscode.action("workbench.action.toggleSidebarVisibility")
end, opts)

keymap("n", "<leader>fw", function()
  vscode.action("workbench.action.findInFiles", { query = vim.fn.expand("<cword>") })
end, opts)

keymap("n", "<leader>ff", function()
  vscode.action("workbench.action.quickOpen")
end, opts)

keymap("n", "<leader>bd", function()
  vscode.action("workbench.action.closeActiveEditor")
end, opts)

keymap("n", "<leader>bD", function()
  vscode.action("workbench.action.closeAllEditors")
end, opts)

keymap("n", "<leader>uz", function()
  vscode.action("workbench.action.toggleZenMode")
end, opts)

keymap("n", "u", "<Cmd>call VSCodeNotify('undo')<CR>", opts)
keymap("n", "<C-r>", "<Cmd>call VSCodeNotify('redo')<CR>", opts)

keymap("n", "<S-h>", "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>", opts)
keymap("n", "<S-l>", "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>", opts)
