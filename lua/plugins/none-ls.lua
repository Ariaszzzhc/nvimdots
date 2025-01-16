local M = {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}

function M.config()
  local null_ls = require("null-ls")

  local formatting = null_ls.builtins.formatting
  local completion = null_ls.builtins.completion

  null_ls.setup({
    debug = false,
    sources = {
      formatting.prettier.with({
        filetype = { "html", "json", "yaml", "javascript", "javascriptreact", "typescript", "typescriptreact" },
        condition = function(utils)
          -- return utils.root_has_file({ ".prettierrc", ".prettierrc.js", ".prettierrc.json", ".prettierrc.yaml",
          -- ".prettierrc.yml" })
          return utils.root_has_file({ "package.json" })
        end,
      }),
      formatting.black,
      completion.spell,
    },
  })
end

return M
