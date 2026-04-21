local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

local keymap = vim.keymap.set

-- Better up/down
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
keymap({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })
keymap({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })

keymap({ "i", "n" }, "<esc>", "<cmd>nohlsearch<cr><esc>", { desc = "Clear search highlights" })
keymap("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

keymap("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
-- keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
-- keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
-- keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })

keymap("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split window vertically" })
keymap("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split window horizontally" })

-- Move Lines
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Better indenting
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

keymap("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
