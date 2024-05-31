require("user.config.mappings")
require("user.config.options")
require("user.config.autocmd")

if not vim.g.vscode then
  require("user.plugin")
end
