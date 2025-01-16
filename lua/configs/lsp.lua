local util = require("lspconfig.util")

-- https://luals.github.io/wiki/settings/
vim.g.markdown_fenced_languages = {
  "ts=typescript",
}

return {
  denols = {
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
  },
  lua_ls = {
    settings = {
      Lua = {
        format = {
          enable = true,
        },
        diagnostics = {
          globals = { "vim", "spec" },
        },
        runtime = {
          version = "LuaJIT",
          special = {
            spec = "require",
          },
        },
        workspace = {
          checkThirdParty = false,
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
        hint = {
          enable = true,
          arrayIndex = "Disable", -- "Enable" | "Auto" | "Disable"
          await = true,
          paramName = "Disable",  -- "All" | "Literal" | "Disable"
          paramType = true,
          semicolon = "Disable",  -- "All" | "SameLine" | "Disable"
          setType = false,
        },
        codeLens = {
          enable = true,
        },
        telemetry = {
          enable = false,
        },
      },
    },

  },
  ts_ls = {
    root_dir = function(startpath)
      local default_pattern = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git")

      local deno_pattern = util.root_pattern("deno.json", "deno.jsonc")

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
        }
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
        }
      },

      completions = {
        completeFunctionCalls = true,
      }
    },
    single_file_support = false,
  },
  jsonls = {
    settiongs = {
      json = {
        schemas = require("schemastore").json.schemas(),
      },
    },
  },
}
