return {
  -- {
  --   "Kaiser-Yang/blink-cmp-avante",
  --   lazy = true,
  -- },
  {
    "L3MON4D3/LuaSnip",
    build = (function()
      if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
        return
      end
      return "make install_jsregexp"
    end)(),
    version = "v2.*",
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      { "nvim-mini/mini.icons" },
      { "rafamadriz/friendly-snippets" },
      { "L3MON4D3/LuaSnip" },
      {
        "xzbdmw/colorful-menu.nvim",
        lazy = true,
        opts = {},
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "super-tab",
        -- ["<Tab>"] = {
        --   function(c)
        --     if c.snippet_active() then
        --       return c.accept()
        --     else
        --       return c.select_and_accept()
        --     end
        --   end,
        --   "snippet_forward",
        --   function()
        --     local sug = require("copilot.suggestion")
        --     if sug.is_visible() then
        --       if vim.api.nvim_get_mode().mode == "i" then
        --         vim.api.nvim_feedkeys(CREATE_UNDO, "n", false)
        --       end
        --       sug.accept()
        --       return true
        --     end
        --   end,
        --   "fallback",
        -- },
      },
      snippets = { preset = "luasnip" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      completion = {
        menu = {
          border = "none",
          draw = {
            -- We don't need label_description now because label and label_description are already
            -- combined together in label by colorful-menu.nvim.
            columns = { { "kind_icon" }, { "label", gap = 1 } },
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              kind = {
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
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
    },
  },
}
