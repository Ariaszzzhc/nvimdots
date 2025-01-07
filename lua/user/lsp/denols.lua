local util = require("lspconfig.util")

-- https://luals.github.io/wiki/settings/
vim.g.markdown_fenced_languages = {
  "ts=typescript",
}


local options = {
  root_dir = function(startpath)
    local node_pattern = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json")

    local default_pattern = util.root_pattern("deno.json", "deno.jsonc", ".git")

    local node_matched = node_pattern(startpath)

    if node_matched == nil then
      return default_pattern(startpath)
    end
  end,

  settings = {
    deno = {
      enable = true,
      inlayHints = {
        enable = "on",
        variableTypes = {
          enable = true,
          functionLikeReturnTypes = {
            enable = true,
          },
          parameterNames = {
            enable = "all",
            suppressWhenArgumentMatchesName = true,
          },
          parameterTypes = {
            enable = true,
          },
          propertyDeclarationTypes = {
            enable = true,
          },
          variableTypes = {
            enable = true,
            suppressWhenTypeMatchesName = true,
          },
        },
      },
    },
  },
  single_file_support = false,
}

return options
