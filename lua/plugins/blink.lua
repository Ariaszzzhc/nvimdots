local M = {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets"
  },
  version = "*",
}

local CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)

function M.config()
  local icons = require("configs.icons")

  local cmp = require("blink.cmp")

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
            if vim.api.nvim_get_mode().mode == "i" then
              vim.api.nvim_feedkeys(CREATE_UNDO, "n", false)
            end
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
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
        }
      },
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
      ghost_text = {
        enabled = false,
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
    },
  }
  cmp.setup(opts)
end

return M
