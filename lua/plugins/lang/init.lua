local M = {
  {
    dir = "zig",
    ft = "zig",
    cond = not vim.g.vscode,
  },
  {
    dir = "typescript",
    ft = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    cond = not vim.g.vscode,
  },
  {
    dir = "lua",
    ft = "lua",
    cond = not vim.g.vscode,
    dependencies = {
      {
        "folke/lazydev.nvim",
        lazy = true,
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
          enabled = function(root_dir)
            return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
          end,
        },
      },
    },
  },
  {
    dir = "json",
    ft = {
      "json",
      "jsonc",
      "json5",
    },
    cond = not vim.g.vscode,
    dependencies = {
      {
        "b0o/schemastore.nvim",
        lazy = true,
      },
    },
  },
  {
    dir = "cpp",
    ft = {
      "cppm",
      "cpp",
      "c",
      "objc",
    },
    cond = not vim.g.vscode,
    dependencies = {
      {
        "p00f/clangd_extensions.nvim",
        lazy = true,
      },
    },
  },
}

local resolved = {}

for _, config in ipairs(M) do
  local plugin_path = vim.fn.stdpath("config") .. "/lua/plugins/lang"

  local rc = vim.tbl_deep_extend("force", config, {
    dir = plugin_path .. "/" .. config.dir,
  })

  table.insert(resolved, rc)
end

return resolved
