local plugin = require("config.plugin")

plugin.add({
  {
    "saghen/blink.cmp",
    version = vim.version.range("1.*"),
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "rafamadriz/friendly-snippets",
      {
        "L3MON4D3/LuaSnip",
        name = "luasnip",
        version = vim.version.range("v2.*"),
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end

          return "make install_jsregexp"
        end)(),
        opts = {
          history = true,
          delete_check_events = "TextChanged",
        },
        config = function(opts)
          local luasnip = require("luasnip")
          luasnip.setup(opts)

          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({
            paths = { vim.fn.stdpath("config") .. "/snippets" },
          })
        end,
      },
      {
        "xzbdmw/colorful-menu.nvim",
        opts = {},
      },
    },
    opts = function()
      local icons = require("config.icons")

      return {
        keymap = {
          preset = "super-tab",
        },
        snippets = { preset = "luasnip" },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
        completion = {
          menu = {
            border = "none",
            draw = {
              columns = { { "kind_icon" }, { "label", gap = 1 } },
              components = {
                kind_icon = {
                  text = function(ctx)
                    return icons.kinds[ctx.kind] or ctx.kind_icon or ""
                  end,
                  highlight = function(ctx)
                    return "BlinkCmpKind" .. (ctx.kind or "Text")
                  end,
                },
                kind = {
                  highlight = function(ctx)
                    return "BlinkCmpKind" .. (ctx.kind or "Text")
                  end,
                },
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
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
        end,
        desc = "Format the current buffer",
      },
    },
    opts = {
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
      stop_after_first = true,
      formatters = {
        deno_fmt = {
          condition = function(ctx)
            local found = vim.fs.find({ "deno.json", "deno.jsonc" }, {
              path = ctx.dirname,
              upward = true,
            })

            return #found > 0
          end,
        },
        biome = {
          condition = function(ctx)
            local found = vim.fs.find({ "biome.json", "biome.jsonc" }, {
              path = ctx.dirname,
              upward = true,
            })

            return #found > 0
          end,
        },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function(opts)
      local servers = {}
      for server, config in pairs(opts or {}) do
        vim.lsp.config(server, config)
        table.insert(servers, server)
      end

      if #servers > 0 then
        vim.lsp.enable(servers)
      end
    end,
  },
})
