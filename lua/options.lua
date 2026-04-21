local opt = vim.opt;

opt.guicursor="n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 15
opt.sidescrolloff = 15

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.signcolumn = "yes"
opt.cmdheight = 1
opt.showmode = false
opt.completeopt = "menuone,noinsert,noselect"
opt.conceallevel = 2
opt.synmaxcol = 300
opt.fillchars:append({ eob = " " })

local undo_dir = vim.fn.expand("~/.nvim/undo")
if vim.fn.isdirectory(undo_dir) == 0 then
    vim.fn.mkdir(undo_dir, "p")
end

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = undo_dir
opt.updatetime = 300
opt.timeoutlen = 500
opt.autoread = true
opt.autowrite = false

opt.hidden = true
opt.errorbells = false
opt.iskeyword:append("-")
opt.mouse = "a"
opt.clipboard:append("unnamedplus")
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldcolumn = "auto"
opt.foldlevel = 99

opt.diffopt:append("linematch:60")
opt.maxmempattern = 20000

require("utils.statuscolumn")
