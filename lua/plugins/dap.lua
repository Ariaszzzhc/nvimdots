local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
    if config.type and config.type == "java" then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return require("dap.utils").splitstr(new_args)
  end
  return config
end

local function import_dap_config()
  local picker = require("fzf-lua")

  picker.files({
    previewer = false,
    prompt = ">",
    cwd = vim.fn.getcwd(),
    fd_opts = "--type f --extension json",
    winopts = {
      title = "Select debug configuration",
    },
    actions = {
      ["default"] = function(selected)
        if selected and #selected > 0 then
          local file = selected[1]:sub(8)
          local data = vim.fn.readfile(file)
          local launch = vim.json.decode(table.concat(data, "\n"))
          local config = launch.configurations

          if config ~= nil then
            local dap = require("dap")
            local ft = vim.bo.filetype

            local dap_config = dap.configurations[ft]

            if dap_config ~= nil then
              dap.configurations[ft] = vim.tbl_deep_extend("force", dap_config, config)
            else
              dap.configurations[ft] = config
            end
          else
            vim.notify("No configurations found in " .. file)
          end
        end
      end,
    },
  })
end

local M = {
  "mfussenegger/nvim-dap",
  cond = not vim.g.vscode,
  dependencies = {
    {
      "nvim-neotest/nvim-nio",
    },
    {
      "rcarriga/nvim-dap-ui",
      keys = {
        {
          "<leader>du",
          function()
            require("dapui").toggle({})
          end,
          desc = "Dap UI",
        },
        {
          "<leader>de",
          function()
            require("dapui").eval()
          end,
          desc = "Eval",
          mode = { "n", "v" },
        },
      },
      config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup()
        dap.listeners.before.attach.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
          dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
          dapui.close()
        end
      end,
    },
    {
      "theHamsta/nvim-dap-virtual-text",
    },
  },
  keys = {
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Breakpoint Condition",
    },
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle Breakpoint",
    },
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "Run/Continue",
    },
    {
      "<leader>da",
      function()
        require("dap").continue({ before = get_args })
      end,
      desc = "Run with Args",
    },
    {
      "<leader>dC",
      function()
        require("dap").run_to_cursor()
      end,
      desc = "Run to Cursor",
    },
    {
      "<leader>dg",
      function()
        require("dap").goto_()
      end,
      desc = "Go to Line (No Execute)",
    },
    {
      "<leader>di",
      function()
        require("dap").step_into()
      end,
      desc = "Step Into",
    },
    {
      "<leader>dj",
      function()
        require("dap").down()
      end,
      desc = "Down",
    },
    {
      "<leader>dk",
      function()
        require("dap").up()
      end,
      desc = "Up",
    },
    {
      "<leader>dL",
      function()
        require("dap").run_last()
      end,
      desc = "Run Last",
    },
    {
      "<leader>dl",
      function()
        require("fzf-lua").dap_configurations()
      end,
      desc = "Run",
    },
    {
      "<leader>do",
      function()
        require("dap").step_out()
      end,
      desc = "Step Out",
    },
    {
      "<leader>dO",
      function()
        require("dap").step_over()
      end,
      desc = "Step Over",
    },
    {
      "<leader>dP",
      function()
        require("dap").pause()
      end,
      desc = "Pause",
    },
    {
      "<leader>dr",
      function()
        require("dap").repl.toggle()
      end,
      desc = "Toggle REPL",
    },
    {
      "<leader>ds",
      function()
        require("dap").session()
      end,
      desc = "Session",
    },
    {
      "<leader>dt",
      function()
        require("dap").terminate()
      end,
      desc = "Terminate",
    },
    {
      "<leader>dw",
      function()
        require("dap.ui.widgets").hover()
      end,
      desc = "Widgets",
    },
    {
      "<leader>dI",
      function()
        import_dap_config()
      end,
      desc = "Load debug configuration",
    },
  },
}

function M.config()
  vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

  local icons = require("configs.icons").dap

  vim.fn.sign_define("DapBreakpoint", {
    text = icons.Breakpoint,
    texthl = "DiagnosticInfo",
  })

  vim.fn.sign_define("DapStopped", {
    text = icons.Stopped,
    texthl = "DiagnosticWarn",
    linehl = "DapStoppedLine",
    numhl = "DapStoppedLine",
  })

  vim.fn.sign_define("DapBreakpointCondition", {
    text = icons.BreakpointCondition,
    texthl = "DiagnosticWarn",
  })

  vim.fn.sign_define("DapBreakpointRejected", {
    text = icons.BreakpointRejected,
    texthl = "DiagnosticError",
  })

  vim.fn.sign_define("DapLogPoint", {
    text = icons.LogPoint,
    texthl = "DiagnosticWarn",
  })

  require("nvim-dap-virtual-text").setup()
end

return M
