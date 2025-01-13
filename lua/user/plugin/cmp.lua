local M = {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets"
  },
  version = "*",
}

function M.config()
  local icons = require("user.ui.icons")

  local cmp = require("blink.cmp")

  --- @type blink.cmp.Config
  local opts = {
    keymap = {
      preset = "super-tab",
      ["<Tab>"] = {
        function(c)
          local copilot = require("copilot.suggestion")
          if c.snippet_active() then
            return c.accept()
          elseif c.is_visible() then
            return c.select_and_accept()
          elseif copilot.is_visible() then
            copilot.accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },
    },
    appearance = {
      kind_icons = icons.kind,
    },
    completion = {
      list = {
        selection = {
          preselect = true,
          auto_insert = true,
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },
    sources = {
      default = {
        "lsp",
        "path",
        "snippets",
        "buffer",
      }
    },
    signature = {
      enabled = true,
    }
  }
  cmp.setup(opts)
end

return M
