local lsp_util = require("lspconfig.util")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "javascript", "typescript" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ts_ls = {
          root_dir = function(startpath)
            local default_pattern = lsp_util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git")

            local deno_pattern = lsp_util.root_pattern("deno.json", "deno.jsonc")

            local deno_matched = deno_pattern(startpath)

            if deno_matched == nil then
              return default_pattern(startpath)
            end
          end,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
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
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
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
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          single_file_support = false,
        },
        denols = {
          root_dir = function(startpath)
            local node_pattern = lsp_util.root_pattern("tsconfig.json", "jsconfig.json", "package.json")

            local default_pattern = lsp_util.root_pattern("deno.json", "deno.jsonc", ".git")

            local node_matched = node_pattern(startpath)

            if node_matched == nil then
              return default_pattern(startpath)
            end
          end,
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
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
        },
        tailwindcss = {},
        eslint = {
          root_dir = function(startpath)
            local pattern = lsp_util.root_pattern(
              "eslint.config.js",
              "eslint.config.mjs",
              "eslint.config.cjs",
              "eslint.config.ts",
              "eslint.config.cts",
              "eslint.config.mts",
              ".eslintrc.js",
              ".eslintrc.mjs",
              ".eslintrc.cjs",
              ".eslintrc.yaml",
              ".eslintrc.yml",
              ".eslintrc.json"
            )

            return pattern(startpath)
          end,
        },
      },
    },
  },
}
