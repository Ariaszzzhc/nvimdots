return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    {
      "ravitemer/mcphub.nvim",
      cmd = "MCPHub",
      opts = {},
    },
  },
  keys = {
    {
      "<leader>ac",
      function()
        require("codecompanion").toggle()
      end,
      desc = "Code Companion",
    },
    {
      "<leader>am",
      function()
        require("codecompanion").actions({})
      end,
    },
  },
  cond = not vim.g.vscode,
  opts = {
    strategies = {
      chat = {
        adapter = "deepseek",
      },
    },
    adapters = {
      deepseek = function()
        local ok, data = pcall(vim.fn.readfile, vim.fn.stdpath("config") .. "/secrets.json")
        local secrets

        if not ok then
          vim.notify("Reading secrets.json file failed!", vim.log.levels.ERROR)
          secrets = {}
        else
          secrets = vim.json.decode(table.concat(data, "\n"))
        end

        return require("codecompanion.adapters").extend("deepseek", {
          env = {
            api_key = secrets.deepseek_api_key,
          },
        })
      end,
    },
    opts = {
      language = "Chinese",
    },
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true,
        },
      },
    },
  },
}
