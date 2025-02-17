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
        vtsls = {
          single_file_support = false,
          root_dir = function(startpath)
            local default_pattern = lsp_util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git")

            local deno_pattern = lsp_util.root_pattern("deno.json", "deno.jsonc")

            local deno_matched = deno_pattern(startpath)

            if deno_matched == nil then
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
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = {
                enabled = "always",
              },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = {
                  enabled = true,
                },
                functionLikeReturnTypes = {
                  enabled = true,
                },
                parameterNames = {
                  enabled = "literals",
                },
                parameterTypes = {
                  enabled = true,
                },
                propertyDeclarationTypes = {
                  enabled = true,
                },
                variableTypes = {
                  enabled = true,
                },
              },
            },
          },
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
      },
    },
  },
}
