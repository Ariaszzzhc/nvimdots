local icons = require("configs.icons")

local CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)

return {
  {
    "nvim-mini/mini.icons",
    priority = 1000,
    lazy = false,
    version = false,
    opts = function()
      return {
        file = {
          [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
          ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
        },
        filetype = {
          dotenv = { glyph = "", hl = "MiniIconsYellow" },
        },
      }
    end,
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
  },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    keys = {
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.git_files()
        end,
        desc = "Find Git Files",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent",
      },
      -- git
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
      },
      {
        "<leader>gb",
        function()
          Snacks.picker.git_branches()
        end,
        desc = "Git Branches",
      },
      {
        "<leader>gl",
        function()
          Snacks.picker.git_log()
        end,
        desc = "Git Log",
      },
      {
        "<leader>gL",
        function()
          Snacks.picker.git_log_line()
        end,
        desc = "Git Log Line",
      },
      {
        "<leader>gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git Status",
      },
      {
        "<leader>gS",
        function()
          Snacks.picker.git_stash()
        end,
        desc = "Git Stash",
      },
      {
        "<leader>gd",
        function()
          Snacks.picker.git_diff()
        end,
        desc = "Git Diff (Hunks)",
      },
      {
        "<leader>gf",
        function()
          Snacks.picker.git_log_file()
        end,
        desc = "Git Log File",
      },
      {
        "<leader>sb",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
      },
      {
        "<leader>sB",
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = "Grep Open Buffers",
      },
      {
        "<leader>sg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>sw",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Visual selection or word",
        mode = { "n", "x" },
      },
      -- search
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = "Registers",
      },
      {
        "<leader>s/",
        function()
          Snacks.picker.search_history()
        end,
        desc = "Search History",
      },
      {
        "<leader>sa",
        function()
          Snacks.picker.autocmds()
        end,
        desc = "Autocmds",
      },
      {
        "<leader>sb",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
      },
      {
        "<leader>sc",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>sC",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>sD",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Buffer Diagnostics",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help Pages",
      },
      {
        "<leader>sH",
        function()
          Snacks.picker.highlights()
        end,
        desc = "Highlights",
      },
      {
        "<leader>si",
        function()
          Snacks.picker.icons()
        end,
        desc = "Icons",
      },
      {
        "<leader>sj",
        function()
          Snacks.picker.jumps()
        end,
        desc = "Jumps",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sl",
        function()
          Snacks.picker.loclist()
        end,
        desc = "Location List",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>sM",
        function()
          Snacks.picker.man()
        end,
        desc = "Man Pages",
      },
      {
        "<leader>sp",
        function()
          Snacks.picker.lazy()
        end,
        desc = "Search for Plugin Spec",
      },
      {
        "<leader>sq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        "<leader>sR",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume",
      },
      {
        "<leader>su",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo History",
      },
      {
        "<leader>uC",
        function()
          Snacks.picker.colorschemes()
        end,
        desc = "Colorschemes",
      },
      {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP Symbols",
      },
      {
        "<leader>sS",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "LSP Workspace Symbols",
      },
      {
        "gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "Goto Definition",
      },
      {
        "gD",
        function()
          Snacks.picker.lsp_declarations()
        end,
        desc = "Goto Declaration",
      },
      {
        "gr",
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = "References",
      },
      {
        "gI",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "Goto Implementation",
      },
      {
        "gy",
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = "Goto T[y]pe Definition",
      },
      {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP Symbols",
      },
    },
    --- @type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      lazygit = {
        enabled = true,
      },
      indent = {
        enabled = true,
      },
      statuscolumn = {
        enabled = true,
      },
      notifier = {
        enabled = true,
      },
      picker = {
        enabled = true,
        layouts = {
          telescope = {
            reverse = true,
            layout = {
              box = "horizontal",
              backdrop = false,
              width = 0.8,
              height = 0.9,
              border = "none",
              {
                box = "vertical",
                { win = "list", title = " Results ", title_pos = "center", border = "single" },
                {
                  win = "input",
                  height = 1,
                  border = "single",
                  title = "{title} {live} {flags}",
                  title_pos = "center",
                },
              },
              {
                win = "preview",
                title = "{preview:Preview}",
                width = 0.45,
                border = "single",
                title_pos = "center",
              },
            },
          },
          dropdawn = {
            layout = {
              backdrop = false,
              row = 1,
              width = 0.4,
              min_width = 80,
              height = 0.8,
              border = "none",
              box = "vertical",
              { win = "preview", title = "{preview}", height = 0.4, border = "single" },
              {
                box = "vertical",
                border = "single",
                title = "{title} {live} {flags}",
                title_pos = "center",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
              },
            },
          },
          ivy = {
            layout = {
              box = "vertical",
              backdrop = false,
              row = -1,
              width = 0,
              height = 0.4,
              border = "top",
              title = " {title} {live} {flags}",
              title_pos = "left",
              { win = "input", height = 1, border = "bottom" },
              {
                box = "horizontal",
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", width = 0.6, border = "left" },
              },
            },
          },
          select = {
            preview = false,
            layout = {
              backdrop = false,
              width = 0.5,
              min_width = 80,
              height = 0.4,
              min_height = 3,
              box = "vertical",
              border = "single",
              title = "{title}",
              title_pos = "center",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
              { win = "preview", title = "{preview}", height = 0.4, border = "top" },
            },
          },
        },
        layout = "select",
        sources = {
          lines = {
            layout = "ivy",
          },
          grep_buffers = {
            layout = "ivy",
          },
          grep = {
            layout = "ivy",
          },
          grep_word = {
            layout = "ivy",
          },
          files = {
            layout = "telescope",
          },
          buffers = {
            layout = "telescope",
          },
          git_files = {
            layout = "telescope",
          },
          recent = {
            layout = "telescope",
          },
          smart = {
            layout = "telescope",
          },
        },
      },
      rename = {
        enabled = true,
      },
      input = {
        enabled = true,
        b = {
          completion = false,
        },
      },
      image = {
        enabled = true,
      },
      zen = {
        toggles = {
          dim = false,
          mini_diff_signs = true,
        },
        show = {
          statusline = true,
          tabline = false,
        },
      },
      styles = {
        input = {
          border = "single",
        },
        blame_line = {
          border = "single",
        },
        notification = {
          border = "single",
        },
        notification_history = {
          border = "single",
        },
        scratch = {
          border = "single",
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "c",
        "cpp",
        "go",
        "lua",
        "python",
        "rust",
        "typescript",
        "javascript",
        "tsx",
        "zig",
        "vimdoc",
        "query",
        "diff",
        "editorconfig",
        "wgsl",
        "yaml",
        "json",
        "toml",
        "astro",
        "markdown",
        "markdown_inline",
      },
      auto_install = true,
      sync_install = false,
      ignore_install = {},
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-mini/mini.misc",
    version = false,
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      local misc = require("mini.misc")

      misc.setup(opts)

      misc.setup_auto_root({ ".git" })
    end,
  },
  {
    "nvim-mini/mini.pairs",
    version = false,
    event = "VeryLazy",
    opts = {
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
  },
  {
    "nvim-mini/mini.cursorword",
    version = false,
    event = "BufEnter",
    opts = {},
  },
  {
    "nvim-mini/mini.ai",
    version = false,
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")

      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          g = function(ai_type)
            local start_line, end_line = 1, vim.fn.line("$")
            if ai_type == "i" then
              -- Skip first and last blank lines for `i` textobject
              local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
              -- Do nothing for buffer with all blanks
              if first_nonblank == 0 or last_nonblank == 0 then
                return { from = { line = start_line, col = 1 } }
              end
              start_line, end_line = first_nonblank, last_nonblank
            end

            local to_col = math.max(vim.fn.getline(end_line):len(), 1)
            return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
          end, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      local ai = require("mini.ai")
      ai.setup(opts)

      local wk = require("which-key")
      local objects = {
        { " ", desc = "whitespace" },
        { '"', desc = '" string' },
        { "'", desc = "' string" },
        { "(", desc = "() block" },
        { ")", desc = "() block with ws" },
        { "<", desc = "<> block" },
        { ">", desc = "<> block with ws" },
        { "?", desc = "user prompt" },
        { "U", desc = "use/call without dot" },
        { "[", desc = "[] block" },
        { "]", desc = "[] block with ws" },
        { "_", desc = "underscore" },
        { "`", desc = "` string" },
        { "a", desc = "argument" },
        { "b", desc = ")]} block" },
        { "c", desc = "class" },
        { "d", desc = "digit(s)" },
        { "e", desc = "CamelCase / snake_case" },
        { "f", desc = "function" },
        { "g", desc = "entire file" },
        { "i", desc = "indent" },
        { "o", desc = "block, conditional, loop" },
        { "q", desc = "quote `\"'" },
        { "t", desc = "tag" },
        { "u", desc = "use/call" },
        { "{", desc = "{} block" },
        { "}", desc = "{} with ws" },
      }

      local ret = { mode = { "o", "x" } }
      local mappings = {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
      }
      mappings.goto_left = nil
      mappings.goto_right = nil

      for name, prefix in pairs(mappings) do
        name = name:gsub("^around_", ""):gsub("^inside_", "")
        ret[#ret + 1] = { prefix, group = name }
        for _, obj in ipairs(objects) do
          local desc = obj.desc
          if prefix:sub(1, 1) == "i" then
            desc = desc:gsub(" with ws", "")
          end
          ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
        end
      end

      wk.add(ret, { notify = false })
    end,
  },
  {
    "nvim-mini/mini.bufremove",
    version = false,
    cond = not vim.g.vscode,
    event = "VeryLazy",
    oprs = {},
  },
  {
    "nvim-mini/mini.surround",
    version = false,
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
        suffix_last = "",
        suffix_next = "",
      },
      search_method = "cover_or_next",
    },
    config = function(_, opts)
      local sur = require("mini.surround")
      sur.setup(opts)

      vim.keymap.del("x", "ys")
      vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
      vim.keymap.set("n", "yss", "ys_", { remap = true })
    end,
  },
  {
    "nvim-mini/mini.move",
    version = false,
    event = "BufEnter",
    opts = {
      mappings = {
        left = "<C-h>",
        right = "<C-l>",
        down = "<C-j>",
        up = "<C-k>",

        line_left = "<C-h>",
        line_right = "<C-l>",
        line_down = "<C-j>",
        line_up = "<C-k>",
      },
    },
  },
  {
    "nvim-mini/mini.diff",
    version = false,
    event = "VeryLazy",
    keys = {
      {
        "<leader>go",
        function()
          require("mini.diff").toggle_overlay(0)
        end,
        desc = "Toggle mini.diff overlay",
      },
    },
    opts = {
      view = {
        style = "sign",
        signs = {
          add = "▎",
          change = "▎",
          delete = "",
        },
      },
    },
  },
  -- {
  --   "nvim-mini/mini.hipatterns",
  --   version = false,
  --   event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  --   cond = not vim.g.vscode,
  --   opts = function()
  --     local hi = require("mini.hipatterns")
  --
  --     return {
  --       highlighters = {
  --         -- hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
  --         -- shorthand = {
  --         --   pattern = "()#%x%x%x()%f[^%x%w]",
  --         --   group = function(_, _, data)
  --         --     ---@type string
  --         --     local match = data.full_match
  --         --     local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
  --         --     local hex_color = "#" .. r .. r .. g .. g .. b .. b
  --         --
  --         --     return hi.compute_hex_color_group(hex_color, "bg")
  --         --   end,
  --         --   extmark_opts = { priority = 2000 },
  --         -- },
  --         tailwind = {
  --           pattern = function()
  --             if
  --               not vim.tbl_contains({
  --                 "astro",
  --                 "css",
  --                 "heex",
  --                 "html",
  --                 "html-eex",
  --                 "javascript",
  --                 "javascriptreact",
  --                 "rust",
  --                 "svelte",
  --                 "typescript",
  --                 "typescriptreact",
  --                 "vue",
  --               }, vim.bo.filetype)
  --             then
  --               return
  --             end
  --             return "%f[%w:-]()[%w:-]+%-[a-z%-]+%-%d+()%f[^%w:-]"
  --           end,
  --           group = function(_, _, m)
  --             ---@type string
  --             local match = m.full_match
  --             ---@type string, number
  --             local color, shade = match:match("[%w-]+%-([a-z%-]+)%-(%d+)")
  --             shade = tonumber(shade) or 0
  --             local bg = vim.tbl_get(_colors, color, shade)
  --             if bg then
  --               local hl = "MiniHipatternsTailwind" .. color .. shade
  --               if not _hl[hl] then
  --                 _hl[hl] = true
  --                 local bg_shade = shade == 500 and 950 or shade < 500 and 900 or 100
  --                 local fg = vim.tbl_get(_colors, color, bg_shade)
  --                 vim.api.nvim_set_hl(0, hl, { fg = "#" .. bg })
  --               end
  --               return hl
  --             end
  --           end,
  --           extmark_opts = function(_, _, m)
  --             ---@type string
  --             local match = m.full_match
  --             ---@type string, number
  --             local color, shade = match:match("[%w-]+%-([a-z%-]+)%-(%d+)")
  --             shade = tonumber(shade) or 0
  --             local bg = vim.tbl_get(_colors, color, shade)
  --             if bg then
  --               local hl = "MiniHipatternsTailwind" .. color .. shade
  --               return {
  --                 virt_text = { { "■ ", hl } }, -- 小方块
  --                 virt_text_pos = "inline",
  --                 priority = 2000,
  --               }
  --             end
  --           end,
  --         },
  --       },
  --     }
  --   end,
  --   config = function(_, opts)
  --     vim.api.nvim_create_autocmd("ColorScheme", {
  --       callback = function()
  --         _hl = {}
  --       end,
  --     })
  --
  --     local hi = require("mini.hipatterns")
  --     hi.setup(opts)
  --   end,
  -- },
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      { "rafamadriz/friendly-snippets" },
      { "L3MON4D3/LuaSnip" },
      {
        "xzbdmw/colorful-menu.nvim",
        lazy = true,
        opts = {},
      },
    },
    opts = {
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
      snippets = { preset = "luasnip" },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
      completion = {
        menu = {
          draw = {
            -- We don't need label_description now because label and label_description are already
            -- combined together in label by colorful-menu.nvim.
            columns = { { "kind_icon" }, { "label", gap = 1 } },
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
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    event = "BufEnter",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      lazy = true,
      opts = {
        enable_autocmd = false,
      },
    },
    opts = {
      pre_hook = function(ctx)
        local hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()

        hook(ctx)
      end,
    },
  },
  {
    "L3MON4D3/LuaSnip",
    build = (function()
      -- Build Step is needed for regex support in snippets.
      -- This step is not supported in many windows environments.
      -- Remove the below condition to re-enable on windows.
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
    "stevearc/conform.nvim",
    event = "BufWritePre",
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
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "deno_fmt", "biome", "prettier" },
        javascriptreact = { "deno_fmt", "biome", "prettier" },
        typescript = { "deno_fmt", "biome", "prettier" },
        typescriptreact = { "deno_fmt", "biome", "prettier" },
        json = { "deno_fmt", "biome", "prettier" },
        yaml = { "deno_fmt", "biome", "prettier" },
        html = { "deno_fmt", "biome", "prettier" },
        css = { "deno_fmt", "biome", "prettier" },
      },
      stop_after_first = true,
      formatters = {
        -- prettier = {
        --   command = "npx",
        --   args = { "prettier", "--stdin-filepath", "$FILENAME" },
        -- },
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
  -- UI
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      win = {
        border = "single",
      },
      spec = {
        mode = { "n", "v" },
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
      {
        "<leader>P",
        function()
          require("lazy").show()
        end,
        desc = "Plugin management",
      },
    },
  },
  {
    "j-hui/fidget.nvim",
    event = "BufReadPre",
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
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
          local dropbar_api = require("dropbar.api")
          dropbar_api.pick()
        end,
        desc = "Pick symbols in winbar",
        mode = "n",
      },
      {
        "[;",
        function()
          local dropbar_api = require("dropbar.api")
          dropbar_api.goto_context_start()
        end,
        desc = "Go to start of current context",
        mode = "n",
      },
      {
        "];",
        function()
          local dropbar_api = require("dropbar.api")
          dropbar_api.select_next_context()
        end,
        desc = "Select next context",
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "MunifTanjim/nui.nvim" },
    },
    keys = {
      {
        "<leader>e",
        "<Cmd>Neotree reveal toggle position=right<CR>",
        mode = "n",
        desc = "Explorer",
      },
    },
    opts = function()
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end
      local events = require("neo-tree.events")
      return {
        close_if_last_window = true,
        popup_border_style = "",
        event_handlers = {
          { event = events.FILE_MOVED, handler = on_move },
          { event = events.FILE_RENAMED, handler = on_move },
        },
      }
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = {
          statusline = { "snacks_dashboard", "snacks_picker_list" },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
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
        lualine_c = { "diagnostics" },
        lualine_x = {
          {
            function()
              return Snacks.profiler.status()
            end,
            cond = function()
              return Snacks.profiler.running()
            end,
          },
          "filetype",
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
          {
            "progress",
            separator = " ",
            padding = { left = 1, right = 0 },
          },
          {
            "location",
            padding = { left = 0, right = 1 },
          },
        },
        lualine_z = {},
      },
      extensions = { "lazy" },
    },
  },
  -- lua lang plugins
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
  -- markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {
      file_types = { "markdown" },
    },
  },
  -- c/c++ lang plugins
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "c", "cpp", "cmake" },
    opts = {},
  },
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp" },
    opts = {},
  },
  -- AI
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        keymap = {
          accept = false,
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = {
        enabled = false,
      },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
    dependencies = {
      "copilotlsp-nvim/copilot-lsp",
    },
  },
}
