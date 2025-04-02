return {

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
      dap.configurations["zig"] = {
        {
          type = "lldb-dap",
          request = "launch",
          name = "Debug Zig(lldb)",
          program = function()
            return coroutine.create(function(dap_run_co)
              picker(function(selected)
                coroutine.resume(dap_run_co, selected)
              end)
            end)
          end,
        },
      }
    end,
  },
}
