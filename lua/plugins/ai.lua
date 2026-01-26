return {
  -- {
  --   "sudo-tee/opencode.nvim",
  --   opts = {},
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "MeanderingProgrammer/render-markdown.nvim",
  --     "saghen/blink.cmp",
  --     "folke/snacks.nvim",
  --   },
  -- },
  -- {
  --   "ravitemer/mcphub.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   build = "npm install -g mcp-hub@latest",
  --   opts = {
  --     avante = {
  --       -- make_slash_commands = true, -- make /slash commands from MCP server prompts
  --     },
  --   },
  -- },
  -- {
  --   "yetone/avante.nvim",
  --   build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
  --     or "make",
  --   event = "VeryLazy",
  --   version = false,
  --   opts = {
  --     disabled_tools = {
  --       "list_files", -- Built-in file operations
  --       "search_files",
  --       "read_file",
  --       "create_file",
  --       "rename_file",
  --       "delete_file",
  --       "create_dir",
  --       "rename_dir",
  --       "delete_dir",
  --       "bash", -- Built-in terminal access
  --     },
  --     input = {
  --       provider = "snacks",
  --       provider_opts = {
  --         -- Additional snacks.input options
  --         title = "Avante Input",
  --         icon = " ",
  --       },
  --     },
  --     provider = "opencode",
  --     acp_providers = {
  --       ["opencode"] = {
  --         command = "opencode",
  --         args = { "acp" },
  --       },
  --     },
  --     system_prompt = function()
  --       local hub = require("mcphub").get_hub_instance()
  --       return hub and hub:get_active_servers_prompt() or ""
  --     end,
  --     custom_tools = function()
  --       return {
  --         require("mcphub.extensions.avante").mcp_tool(),
  --       }
  --     end,
  --   },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --   },
  -- },
  {
    "olimorris/codecompanion.nvim",
    opts = {
      interactions = {
        chat = {
          adapter = "opencode",
        },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
            show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
            add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
            show_result_in_chat = true, -- Show tool results directly in chat buffer
            format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
            make_vars = true, -- Convert MCP resources to #variables for prompts
            make_slash_commands = true, -- Add MCP prompts as /slash commands
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
    },
  },
}
