local M = {
  setup = function()
    local utils = require("utils")
    local has_lsp, lsp = pcall(require, "lspconfig")

    if has_lsp then
      local clangd_opts = {
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      }

      require("clangd_extensions").setup()

      lsp.clangd.setup({
        capabilities = vim.deepcopy(utils.lsp_capabilities),
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
          "--function-arg-placeholders",
          "--fallback-style=google",
          "--experimental-modules-support",
        },
      })
    end
  end,
}

return M
