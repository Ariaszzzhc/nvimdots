local plugin = require("config.plugin")

plugin.add({
  {
    "j-hui/fidget.nvim",
    event = "BufReadPre",
    opts = {},
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "BufReadPre",
    opts = {
      menu = {
        preview = false,
      },
    },
    keys = {
      {
        "<leader>;",
        function()
          require("dropbar.api").pick()
        end,
        desc = "Pick symbols in winbar",
        mode = "n",
      },
      {
        "[;",
        function()
          require("dropbar.api").goto_context_start()
        end,
        desc = "Go to start of current context",
        mode = "n",
      },
      {
        "];",
        function()
          require("dropbar.api").select_next_context()
        end,
        desc = "Select next context",
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        {
          mode = { "n", "x" },
          { "<leader><tab>", group = "tabs" },
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debug" },
          { "<leader>dp", group = "profiler" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          { "<leader>t", group = "terminal" },
          { "<leader>u", group = "ui" },
          { "<leader>x", group = "diagnostics/quickfix" },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
          { "z", group = "fold" },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          { "gx", desc = "Open with system app" },
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local icons = require("config.icons")
      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "snacks_dashboard" } },
          component_separators = "",
          section_separators = "",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            {
              "diff",
              symbols = {
                added = icons.git.Added,
                modified = icons.git.Modified,
                removed = icons.git.Removed,
              },
              source = function()
                local summary = vim.b.minidiff_summary
                return summary
                  and {
                    added = summary.add,
                    modified = summary.change,
                    removed = summary.delete,
                  }
              end,
            },
          },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },
          lualine_x = {
            {
              "fileformat",
              icons_enabled = true,
              symbols = {
                unix = "LF",
                dos = "CRLF",
                mac = "CR",
              },
            },
          },
          lualine_y = {
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename" },
          },
          lualine_z = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
        },
      }
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = { "BufAdd", "BufDelete" },
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    },
    opts = {
      options = {
        mode = "buffers",
        show_buffer_close_icons = false,
        show_close_icon = false,
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "snacks_layout_box",
            text = "File Explorer",
            text_align = "left",
            separator = true,
          },
        },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { border = "single" })
      end,
    },
    config = function(opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },
})
