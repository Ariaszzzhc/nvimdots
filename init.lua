require("configs.mappings")
require("configs.options")
require("configs.autocmd")
require("plugins")

if not vim.g.vscode then
  vim.cmd([[colorscheme tokyonight]])
end
