return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        zls = {},
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "zig" },
    },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      local picker = require("utils").exe_picker
      dap.configurations.zig = {
        {
          type = "lldb-dap",
          request = "launch",
          name = "Debug Zig(lldb)",
          program = function()
            return coroutine.create(function(dap_run_co)
              picker(function(selected)
                if selected and #selected > 0 then
                  local file = selected[1]:sub(8)
                  coroutine.resume(dap_run_co, file)
                end
                coroutine.resume(dap_run_co, dap.ABORT)
              end)
            end)
          end,
        },
      }
    end,
  },
}
