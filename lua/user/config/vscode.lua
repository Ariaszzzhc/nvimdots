local vscode = require("vscode")

local opts = { noremap = true, silent = true }

vim.notify = vscode.notify

-- key mappings

local keymap = vim.keymap.set

-- for source config
keymap("n", "<leader>L", "<cmd>lua require('vscode').action('vscode-neovim.restart')<CR>")

keymap("n", "<leader>e", "<cmd>lua require('vscode').action('workbench.action.toggleSidebarVisibility')<CR>")
keymap("n", "<leader>fw", "<cmd>lua require('vscode').action('workbench.action.findInFiles', { args = { query = vim.fn.expand('<cword>') } })<CR>")
keymap("n", "<leader>ff", "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>")
keymap("n", "<leader>;", "<cmd>lua require('vscode').action('workbench.action.terminal.toggleTerminal')<CR>")
keymap("n", "<leader>q", "<cmd>lua require('vscode').action('workbench.action.closeActiveEditor')<CR>")
keymap("n", "<leader>Q", "<cmd>lua require('vscode').action('workbench.action.closeAllEditors')<CR>")
keymap("n", "<leader>z", "<cmd>lua require('vscode').action('workbench.action.toggleZenMode')<CR>")
