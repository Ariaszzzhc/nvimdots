vim.g.mapleader = " "

local keymap = vim.keymap.set

local opts = { noremap = true, silent = true }

-- keymap("i", "jk", "<ESC>", opts)
-- keymap("i", "kj", "<ESC>", opts)

keymap("t", "<C-;>", "<c-\\><c-n>", opts)

keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

keymap("v", "<S-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<S-k>", ":m '<-2<CR>gv=gv", opts)
keymap("v", "p", '"_dP', opts)
