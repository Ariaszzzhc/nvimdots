return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "cpp" },
    },
  },
  {
    "p00f/clangd_extensions.nvim",
    ft = {
      "c",
      "cpp",
      "objc",
    },
    opts = {
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
    },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      local picker = require("utils").exe_picker

      local config = {
        {
          type = "lldb-dap",
          request = "launch",
          name = "Debug C/CPP (lldb)",
          program = function()
            return coroutine.create(function(dap_run_co)
              picker(function(selected)
                coroutine.resume(dap_run_co, selected)
              end)
            end)
          end,
        },
      }

      dap.configurations.c = config
      dap.configurations.cpp = config
    end,
  },
  {
    "Mythos-404/xmake.nvim",
    event = "BufReadPost",
    opts = {
      runner = {
        type = "snacks",
        config = {
          snacks = {
            position = "float",
            interactive = true,
          },
        },
      },
    },
  },
}
