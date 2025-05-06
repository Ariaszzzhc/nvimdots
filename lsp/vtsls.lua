return {
  cmd = { "vtsls", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = {
          enabled = "literals",
        },
        variableTypes = {
          enabled = true,
        },
        propertyDeclarationTypes = {
          enabled = true,
        },
        parameterTypes = {
          enabled = true,
        },
        functionLikeReturnTypes = {
          enabled = true,
        },
        enumMemberValues = {
          enabled = true,
        },
      },
      referencesCodeLens = {
        enabled = true,
        showOnAllFunctions = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
    },
    javascript = {
      inlayHints = {
        parameterNames = {
          enabled = "literals",
        },
        variableTypes = {
          enabled = true,
        },
        propertyDeclarationTypes = {
          enabled = true,
        },
        parameterTypes = {
          enabled = true,
        },
        functionLikeReturnTypes = {
          enabled = true,
        },
        enumMemberValues = {
          enabled = true,
        },
      },
      referencesCodeLens = {
        enabled = true,
        showOnAllFunctions = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
    },

    completions = {
      completeFunctionCalls = true,
    },
  },
  workspace_required = true,
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json" },
}
