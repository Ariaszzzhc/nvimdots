local colorscheme = "tokyonight"

require("configs.mappings")
require("configs.options")
require("configs.autocmd")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "folke/lazy.nvim", version = "*" },
    { import = "plugins.core" },
    { import = "plugins.ui" },
    { import = "plugins.ai" },
    { import = "plugins.misc" },
    { import = "plugins.lang" },
  },
  install = {
    colorscheme = { colorscheme },
  },
})

if vim.g.vscode then
  require("configs.vscode")
else
  require("configs.lsp")
end

if not vim.g.vscode then
  -- vim.cmd([[colorscheme rose-pine-dawn]])
  vim.cmd("colorscheme " .. colorscheme)
  -- vim.cmd([[colorscheme rose-pine]])
end
