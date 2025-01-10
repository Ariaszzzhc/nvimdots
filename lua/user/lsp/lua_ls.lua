-- https://luals.github.io/wiki/settings/
local options = {
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
}

return options
