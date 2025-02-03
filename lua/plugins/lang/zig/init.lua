local picker = require("utils").exe_picker

local M = {
  setup = function()
    local utils = require("utils")
    local has_lsp, lsp = pcall(require, "lspconfig")
    local has_dap, dap = pcall(require, "dap")

    if has_lsp then
      lsp.zls.setup({
        capabilities = utils.lsp_capabilities,
      })
    end

    if has_dap then
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
    end

    vim.api.nvim_create_user_command("ZigRun", function()
      Snacks.terminal("zig build run", {
        interactive = false,
      })
    end, { desc = "Build and run current zig project" })

    vim.api.nvim_create_user_command("ZigBuild", function()
      Snacks.terminal("zig build")
    end, { desc = "Build current zig project" })

    vim.api.nvim_create_user_command("ZigTest", function()
      Snacks.terminal("zig test", {
        interactive = false,
      })
    end, { desc = "Test current zig project" })

    vim.api.nvim_create_user_command("ZigRunCurrent", function()
      local file = vim.api.nvim_buf_get_name(0)

      Snacks.terminal("zig run " .. file, {
        interactive = false,
      })
    end, { desc = "Build and run current zig file" })
  end,
}

return M
