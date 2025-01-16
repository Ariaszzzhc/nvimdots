-- if vim.g.vscode then
--   require("user.config.mappings")
--   require("user.config.options")
--   require("user.config.vscode")
-- else
--   require("user.config.mappings")
--   require("user.config.options")
--   require("user.config.autocmd")
--   require("user.plugin")
-- end

require("configs.mappings")
require("configs.options")
require("configs.autocmd")
require("plugins")

vim.cmd [[colorscheme tokyonight]]
