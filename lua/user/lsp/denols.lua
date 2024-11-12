-- https://luals.github.io/wiki/settings/
vim.g.markdown_fenced_languages = {
  "ts=typescript",
}

return {
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
          }
        }
      }
    }
  }
}
