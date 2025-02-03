local M = {
  setup = function()
    local utils = require("utils")
    local has_lsp, lsp = pcall(require, "lspconfig")

    if has_lsp then
      local server_opts = {
        settings = {
          Lua = {
            format = {
              enable = true,
            },
            hint = {
              enable = true,
              arrayIndex = "Disable", -- "Enable" | "Auto" | "Disable"
              await = true,
              paramName = "Disable", -- "All" | "Literal" | "Disable"
              paramType = true,
              semicolon = "Disable", -- "All" | "SameLine" | "Disable"
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
        capabilities = vim.deepcopy(utils.lsp_capabilities),
      }

      lsp.lua_ls.setup(server_opts)
    end
  end,
}

return M
