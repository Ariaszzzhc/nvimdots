local plugin = require("plugin")
local pickers = require("utils.pickers")

plugin.add(
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
  },
  {
    "nvim-mini/mini.bufremove",
    enabled = not vim.g.vscode,
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete()
        end,
        desc = "Delete Buffer",
      },
      { "<leader>bD", "<Cmd>bd<CR>", desc = "Delete Buffer and Window" },
    },
  },
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = "startup",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function() end,
  },
  {
    "nvim-mini/mini.comment",
    event = "VeryLazy",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = {
          enable_autocmd = false,
        },
        config = function(opts)
          require("ts_context_commentstring").setup(opts)
        end,
      },
    },
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "folke/which-key.nvim",
    },
    opts = function()
      local ai = require("mini.ai")

      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" },
          e = {
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          g = function(ai_type)
            local start_line, end_line = 1, vim.fn.line("$")
            if ai_type == "i" then
              local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
              if first_nonblank == 0 or last_nonblank == 0 then
                return { from = { line = start_line, col = 1 } }
              end
              start_line, end_line = first_nonblank, last_nonblank
            end

            local to_col = math.max(vim.fn.getline(end_line):len(), 1)
            return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
          end,
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
        },
      }
    end,
    config = function(opts)
      require("mini.ai").setup(opts)

      vim.schedule(function()
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
        local mappings = vim.tbl_extend("force", {}, {
          around = "a",
          inside = "i",
          around_next = "an",
          inside_next = "in",
          around_last = "al",
          inside_last = "il",
        }, opts.mappings or {})
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
            ret[#ret + 1] = { prefix .. obj[1], desc = desc }
          end
        end

        require("which-key").add(ret, { notify = false })
      end)
    end,
  },
  {
    "nvim-mini/mini.diff",
    event = "VeryLazy",
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
    keys = {
      {
        "<leader>go",
        function()
          require("mini.diff").toggle_overlay(0)
        end,
        desc = "Toggle mini.diff overlay",
      },
    },
  },
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
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      { "fzf-native", "hide" },
      fzf_colors = true,
      files = {
        fd_opts = "--color=never --type f --hidden --follow --exclude .git",
      },
      grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git/*' -e",
      },
      oldfiles = {
        include_current_session = true,
      },
      winopts = {
        height = 0.85,
        width = 0.85,
        row = 0.5,
        col = 0.5,
        preview = {
          default = "bat",
          layout = "flex",
          vertical = "down:45%",
          horizontal = "right:55%",
        },
      },
    },
    keys = {
      { "<leader><space>", pickers.run("global"), desc = "Smart Find" },
      { "<leader>,", pickers.run("buffers"), desc = "Buffers" },
      { "<leader>/", pickers.run("live_grep"), desc = "Grep" },
      { "<leader>:", pickers.run("command_history"), desc = "Command History" },
      { "<leader>n", pickers.notifications, desc = "Notification History" },

      { "<leader>fb", pickers.run("buffers"), desc = "Buffers" },
      { "<leader>fc", pickers.config_files, desc = "Find Config File" },
      { "<leader>ff", pickers.run("files"), desc = "Find Files" },
      { "<leader>fg", pickers.run("git_files"), desc = "Find Git Files" },
      { "<leader>fp", pickers.projects, desc = "Projects" },
      { "<leader>fr", pickers.run("oldfiles"), desc = "Recent" },

      { "<leader>gb", pickers.run("git_branches"), desc = "Git Branches" },
      { "<leader>gl", pickers.run("git_commits"), desc = "Git Log" },
      { "<leader>gL", pickers.run("git_blame"), desc = "Git Log Line" },
      { "<leader>gs", pickers.run("git_status"), desc = "Git Status" },
      { "<leader>gS", pickers.run("git_stash"), desc = "Git Stash" },
      { "<leader>gd", pickers.run("git_hunks"), desc = "Git Diff Hunks" },
      { "<leader>gf", pickers.run("git_bcommits"), desc = "Git Log File" },
      { "<leader>gi", pickers.gh("issue", "open"), desc = "GitHub Issues (open)" },
      { "<leader>gI", pickers.gh("issue", "all"), desc = "GitHub Issues (all)" },
      { "<leader>gp", pickers.gh("pr", "open"), desc = "GitHub Pull Requests (open)" },
      { "<leader>gP", pickers.gh("pr", "all"), desc = "GitHub Pull Requests (all)" },

      { "<leader>sb", pickers.run("blines"), desc = "Buffer Lines" },
      { "<leader>sB", pickers.run("lines"), desc = "Open Buffer Lines" },
      { "<leader>sg", pickers.run("live_grep"), desc = "Grep" },
      { "<leader>sw", pickers.grep_word, desc = "Visual selection or word", mode = { "n", "x" } },
      { '<leader>s"', pickers.run("registers"), desc = "Registers" },
      { "<leader>s/", pickers.run("search_history"), desc = "Search History" },
      { "<leader>sa", pickers.run("autocmds"), desc = "Autocmds" },
      { "<leader>sc", pickers.run("command_history"), desc = "Command History" },
      { "<leader>sC", pickers.run("commands"), desc = "Commands" },
      { "<leader>sd", pickers.run("diagnostics_workspace"), desc = "Diagnostics" },
      { "<leader>sD", pickers.run("diagnostics_document"), desc = "Buffer Diagnostics" },
      { "<leader>sh", pickers.run("helptags"), desc = "Help Pages" },
      { "<leader>sH", pickers.run("highlights"), desc = "Highlights" },
      { "<leader>si", pickers.icons, desc = "Icons" },
      { "<leader>sj", pickers.run("jumps"), desc = "Jumps" },
      { "<leader>sk", pickers.run("keymaps"), desc = "Keymaps" },
      { "<leader>sl", pickers.run("loclist"), desc = "Location List" },
      { "<leader>sm", pickers.run("marks"), desc = "Marks" },
      { "<leader>sM", pickers.run("manpages"), desc = "Man Pages" },
      { "<leader>sp", pickers.plugin_specs, desc = "Search for Plugin Spec" },
      { "<leader>sq", pickers.run("quickfix"), desc = "Quickfix List" },
      { "<leader>sR", pickers.run("resume"), desc = "Resume" },
      { "<leader>su", pickers.run("undotree"), desc = "Undo History" },
      { "<leader>uC", pickers.run("colorschemes"), desc = "Colorschemes" },

      { "gd", pickers.run("lsp_definitions"), desc = "Goto Definition" },
      { "gD", pickers.run("lsp_declarations"), desc = "Goto Declaration" },
      { "gr", pickers.run("lsp_references"), nowait = true, desc = "References" },
      { "gI", pickers.run("lsp_implementations"), desc = "Goto Implementation" },
      { "gy", pickers.run("lsp_typedefs"), desc = "Goto Type Definition" },
      { "gai", pickers.run("lsp_incoming_calls"), desc = "Calls Incoming" },
      { "gao", pickers.run("lsp_outgoing_calls"), desc = "Calls Outgoing" },
      { "<leader>ss", pickers.run("lsp_document_symbols"), desc = "LSP Symbols" },
      { "<leader>sS", pickers.run("lsp_workspace_symbols"), desc = "LSP Workspace Symbols" },
      { "<leader>st", pickers.todo(), desc = "Todo" },
      { "<leader>sT", pickers.todo({ "TODO", "FIX", "FIXME" }), desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = { signs = false },
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next Todo Comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous Todo Comment",
      },
    },
  },
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
      local icons = require("icons")

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
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
    opts = {
      file_types = { "markdown", "opencode_output", "Avante" },
    },
  },
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "c", "cpp", "cmake" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {},
  },
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp" },
    opts = {},
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local icons = require("icons")
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
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
      lua_ls = {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
              path ~= vim.fn.stdpath("config")
              and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using (most
              -- likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
              -- Tell the language server how to find Lua modules same way as Neovim
              -- (see `:h lua-module-load`)
              path = {
                "lua/?.lua",
                "lua/?/init.lua",
              },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                -- TODO: add Snacks

                -- Depending on the usage, you might want to add additional paths
                -- here.
                "${3rd}/luv/library",
                -- '${3rd}/busted/library',
              },
              -- Or pull in all of 'runtimepath'.
              -- NOTE: this is a lot slower and will cause issues when working on
              -- your own configuration.
              -- See https://github.com/neovim/nvim-lspconfig/issues/3189
              -- library = vim.api.nvim_get_runtime_file('', true),
            },
          })
        end,
        settings = {
          Lua = {},
        },
      },
    },
    config = function(opts)
      local servers = {}
      for server, config in pairs(opts) do
        vim.lsp.config(server, config)
        table.insert(servers, server)
      end
      vim.lsp.enable(servers)
    end,
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {},
    config = function()
      vim.notify = require("notify")
    end,
  }
)

plugin.flush()
