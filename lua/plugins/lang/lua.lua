return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "lua" },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
      },
      enabled = function(root_dir)
        return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
      end,
    },
    dependencies = {
      "LelouchHe/xmake-luals-addon",
      name = "xmake-luals-addon",
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
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
        },
      },
    },
  },
}
