local M = {
  "saghen/blink.cmp",
  dependencies = {
    { "rafamadriz/friendly-snippets" },
    {
      "xzbdmw/colorful-menu.nvim",
      opts = {},
    },
  },
  cond = not vim.g.vscode,
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
          if c.snippet_active() then
            return c.accept()
          else
            return c.select_and_accept()
          end
        end,
        "snippet_forward",
        function()
          local sug = require("copilot.suggestion")
          if sug.is_visible() then
            if vim.api.nvim_get_mode().mode == "i" then
              vim.api.nvim_feedkeys(CREATE_UNDO, "n", false)
            end
            sug.accept()
            return true
          end
        end,
        "fallback",
      },
    },
    appearance = {
      kind_icons = icons.kind,
    },
    completion = {
      accept = {
        auto_brackets = {
          enabled = false,
        },
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
          columns = {
            { "kind_icon" },
            { "label", gap = 1 },
          },
          components = {
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
          },
        },
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
        "lazydev",
        "lsp",
        "path",
        "snippets",
        "buffer",
        "markdown",
      },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        markdown = {
          name = "RenderMarkdown",
          module = "render-markdown.integ.blink",
          score_offset = 100,
          fallbacks = { "lsp" },
        },
      },
    },
    signature = {
      enabled = true,
    },
    snippets = {
      expand = function(snippet)
        if not _G.MiniSnippets then
          error("mini.snippets has not been setup")
        end
        local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
        insert({ body = snippet })
      end,
      active = function()
        if not _G.MiniSnippets then
          error("mini.snippets has not been setup")
        end
        return MiniSnippets.session.get(false) ~= nil
      end,
      jump = function(direction)
        if not _G.MiniSnippets then
          error("mini.snippets has not been setup")
        end
        MiniSnippets.session.jump(direction == -1 and "prev" or "next")
      end,
    },
    cmdline = {
      enabled = true,
    },
  }
  cmp.setup(opts)
end

return M
