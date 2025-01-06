if vim.g.vscode then
  require("user.config.mappings")
  require("user.config.options")
  require("user.config.vscode")
else
  require("user.config.mappings")
  require("user.config.options")
  require("user.config.autocmd")
  require("user.plugin")
end
