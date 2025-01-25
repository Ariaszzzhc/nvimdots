local dap = require("dap")
local picker = require("fzf-lua")

local function exe_picker(exe_cb)
  picker.files({
    previewer = false,
    prompt = "> ",
    cwd = vim.fn.getcwd(),
    fd_opts = "--type x",
    actions = {
      ["default"] = exe_cb,
    },
    winopts = {
      title = "Select executable",
    },
  })
end

return {
  zig = {
    {
      type = "lldb-dap",
      request = "launch",
      name = "Debug Zig(lldb)",
      program = function()
        return coroutine.create(function(dap_run_co)
          exe_picker(function(selected)
            if selected and #selected > 0 then
              local file = selected[1]:sub(8)

              coroutine.resume(dap_run_co, file)
            end

            coroutine.resume(dap_run_co, dap.ABORT)
          end)
        end)
      end,
    },
  },
  c = {
    {
      type = "lldb-dap",
      request = "launch",
      name = "Debug C(lldb)",
      program = function()
        return coroutine.create(function(dap_run_co)
          exe_picker(function(selected)
            if selected and #selected > 0 then
              local file = selected[1]:sub(8)

              coroutine.resume(dap_run_co, file)
            end

            coroutine.resume(dap_run_co, dap.ABORT)
          end)
        end)
      end,
    },
  },
  cpp = {
    {
      type = "lldb-dap",
      request = "launch",
      name = "Debug Cpp(lldb)",
      program = function()
        return coroutine.create(function(dap_run_co)
          exe_picker(function(selected)
            if selected and #selected > 0 then
              local file = selected[1]:sub(8)

              coroutine.resume(dap_run_co, file)
            end

            coroutine.resume(dap_run_co, dap.ABORT)
          end)
        end)
      end,
    },
  },
  rust = {
    {
      type = "lldb-dap",
      request = "launch",
      name = "Debug Rust(lldb)",
      program = function()
        return coroutine.create(function(dap_run_co)
          exe_picker(function(selected)
            if selected and #selected > 0 then
              local file = selected[1]:sub(8)

              coroutine.resume(dap_run_co, file)
            end

            coroutine.resume(dap_run_co, dap.ABORT)
          end)
        end)
      end,
    },
  },
}
