return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      dap.adapters["lldb-dap"] = {
        type = "executable",
        command = "lldb-dap",
        name = "lldb",
      }
    end,
  },
}
