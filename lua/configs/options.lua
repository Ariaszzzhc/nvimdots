vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.confirm = true
vim.opt.conceallevel = 2
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.swapfile = false
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.timeoutlen = 300
vim.opt.updatetime = 200
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.title = true
vim.opt.virtualedit = "block"
vim.opt.winminwidth = 5
vim.opt.foldlevel = 99
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
vim.opt.shiftround = true
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.foldcolumn = "auto"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.fillchars:append({ eob = " " })
vim.opt.laststatus = 3

vim.g.netrw_banner = 0
vim.g.netrw_mouse = 2
vim.g.markdown_recommended_style = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.mapleader = " "

vim.opt.guifont = "OperatorMonoSSmLig Nerd Font:h15:w1"

if vim.g.neovide then
  vim.g.neovide_remember_window_size = true
end
