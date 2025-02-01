local M = {
  "echasnovski/mini.nvim",
  version = false,
  priority = 1000,
  lazy = false,
}

local function setup_starter()
  if vim.o.filetype == "lazy" then
    vim.cmd.close()
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniStarterOpened",
      callback = function()
        require("lazy").show()
      end,
    })
  end

  local starter = require("mini.starter")
  local logo = table.concat({
    [[                               __                ]],
    [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
    [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
    [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
    [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
    [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
  }, "\n")

  local pad = string.rep(" ", 22)

  local new_section = function(name, action, section)
    return { name = name, action = action, section = pad .. section }
  end

  local picker = require("fzf-lua")

  local opts = {
    header = logo,
    evaluate_single = true,
    items = {
      new_section("Find file", picker.files, "Picker"),
      new_section("Recent files", picker.oldfiles, "Picker"),
      new_section("Find text", picker.live_grep, "Picker"),
      new_section("New file", "ene | startinsert", "Built-in"),
      new_section("Quit", "qa", "Built-in"),
      new_section("Config", function()
        picker.files({
          cwd = vim.fn.stdpath("config"),
        })
      end, "Config"),
      new_section("Update", function()
        vim.cmd([[ Lazy update ]])
      end, "Config"),
    },
    content_hooks = {
      starter.gen_hook.adding_bullet(pad .. "░ ", false),
      starter.gen_hook.aligning("center", "center"),
    },
  }

  starter.setup(opts)

  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    callback = function(event)
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      local pad_footer = string.rep(" ", 8)

      starter.config.footer = pad_footer .. "Loaded " .. stats.count .. " plugins in " .. ms .. "ms"

      if vim.bo[event.buf].filetype == "ministarter" then
        pcall(starter.refresh)
      end
    end,
  })
end

local function setup_autopair()
  require("mini.pairs").setup({
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    skip_ts = { "string" },
    skip_unbalanced = true,
    markdown = true,
  })
end

local function setup_icons()
  local icons = require("configs.icons")

  local mini_icons = require("mini.icons")
  mini_icons.setup({
    file = {
      [".keep"] = { glyph = icons.git.Repe, hl = "MiniIconsGrey" },
      ["devcontainer.json"] = { glyph = icons.misc.Package, hl = "MiniIconsAzure" },
    },
    filetype = {
      dotenv = { glyph = icons.ui.Gear, hl = "MiniIconsYellow" },
    },
  })

  mini_icons.mock_nvim_web_devicons()
end

local function setup_cursorword()
  require("mini.cursorword").setup()
end

local colors = {
  slate = {
    [50] = "f8fafc",
    [100] = "f1f5f9",
    [200] = "e2e8f0",
    [300] = "cbd5e1",
    [400] = "94a3b8",
    [500] = "64748b",
    [600] = "475569",
    [700] = "334155",
    [800] = "1e293b",
    [900] = "0f172a",
    [950] = "020617",
  },

  gray = {
    [50] = "f9fafb",
    [100] = "f3f4f6",
    [200] = "e5e7eb",
    [300] = "d1d5db",
    [400] = "9ca3af",
    [500] = "6b7280",
    [600] = "4b5563",
    [700] = "374151",
    [800] = "1f2937",
    [900] = "111827",
    [950] = "030712",
  },

  zinc = {
    [50] = "fafafa",
    [100] = "f4f4f5",
    [200] = "e4e4e7",
    [300] = "d4d4d8",
    [400] = "a1a1aa",
    [500] = "71717a",
    [600] = "52525b",
    [700] = "3f3f46",
    [800] = "27272a",
    [900] = "18181b",
    [950] = "09090B",
  },

  neutral = {
    [50] = "fafafa",
    [100] = "f5f5f5",
    [200] = "e5e5e5",
    [300] = "d4d4d4",
    [400] = "a3a3a3",
    [500] = "737373",
    [600] = "525252",
    [700] = "404040",
    [800] = "262626",
    [900] = "171717",
    [950] = "0a0a0a",
  },

  stone = {
    [50] = "fafaf9",
    [100] = "f5f5f4",
    [200] = "e7e5e4",
    [300] = "d6d3d1",
    [400] = "a8a29e",
    [500] = "78716c",
    [600] = "57534e",
    [700] = "44403c",
    [800] = "292524",
    [900] = "1c1917",
    [950] = "0a0a0a",
  },

  red = {
    [50] = "fef2f2",
    [100] = "fee2e2",
    [200] = "fecaca",
    [300] = "fca5a5",
    [400] = "f87171",
    [500] = "ef4444",
    [600] = "dc2626",
    [700] = "b91c1c",
    [800] = "991b1b",
    [900] = "7f1d1d",
    [950] = "450a0a",
  },

  orange = {
    [50] = "fff7ed",
    [100] = "ffedd5",
    [200] = "fed7aa",
    [300] = "fdba74",
    [400] = "fb923c",
    [500] = "f97316",
    [600] = "ea580c",
    [700] = "c2410c",
    [800] = "9a3412",
    [900] = "7c2d12",
    [950] = "431407",
  },

  amber = {
    [50] = "fffbeb",
    [100] = "fef3c7",
    [200] = "fde68a",
    [300] = "fcd34d",
    [400] = "fbbf24",
    [500] = "f59e0b",
    [600] = "d97706",
    [700] = "b45309",
    [800] = "92400e",
    [900] = "78350f",
    [950] = "451a03",
  },

  yellow = {
    [50] = "fefce8",
    [100] = "fef9c3",
    [200] = "fef08a",
    [300] = "fde047",
    [400] = "facc15",
    [500] = "eab308",
    [600] = "ca8a04",
    [700] = "a16207",
    [800] = "854d0e",
    [900] = "713f12",
    [950] = "422006",
  },

  lime = {
    [50] = "f7fee7",
    [100] = "ecfccb",
    [200] = "d9f99d",
    [300] = "bef264",
    [400] = "a3e635",
    [500] = "84cc16",
    [600] = "65a30d",
    [700] = "4d7c0f",
    [800] = "3f6212",
    [900] = "365314",
    [950] = "1a2e05",
  },

  green = {
    [50] = "f0fdf4",
    [100] = "dcfce7",
    [200] = "bbf7d0",
    [300] = "86efac",
    [400] = "4ade80",
    [500] = "22c55e",
    [600] = "16a34a",
    [700] = "15803d",
    [800] = "166534",
    [900] = "14532d",
    [950] = "052e16",
  },

  emerald = {
    [50] = "ecfdf5",
    [100] = "d1fae5",
    [200] = "a7f3d0",
    [300] = "6ee7b7",
    [400] = "34d399",
    [500] = "10b981",
    [600] = "059669",
    [700] = "047857",
    [800] = "065f46",
    [900] = "064e3b",
    [950] = "022c22",
  },

  teal = {
    [50] = "f0fdfa",
    [100] = "ccfbf1",
    [200] = "99f6e4",
    [300] = "5eead4",
    [400] = "2dd4bf",
    [500] = "14b8a6",
    [600] = "0d9488",
    [700] = "0f766e",
    [800] = "115e59",
    [900] = "134e4a",
    [950] = "042f2e",
  },

  cyan = {
    [50] = "ecfeff",
    [100] = "cffafe",
    [200] = "a5f3fc",
    [300] = "67e8f9",
    [400] = "22d3ee",
    [500] = "06b6d4",
    [600] = "0891b2",
    [700] = "0e7490",
    [800] = "155e75",
    [900] = "164e63",
    [950] = "083344",
  },

  sky = {
    [50] = "f0f9ff",
    [100] = "e0f2fe",
    [200] = "bae6fd",
    [300] = "7dd3fc",
    [400] = "38bdf8",
    [500] = "0ea5e9",
    [600] = "0284c7",
    [700] = "0369a1",
    [800] = "075985",
    [900] = "0c4a6e",
    [950] = "082f49",
  },

  blue = {
    [50] = "eff6ff",
    [100] = "dbeafe",
    [200] = "bfdbfe",
    [300] = "93c5fd",
    [400] = "60a5fa",
    [500] = "3b82f6",
    [600] = "2563eb",
    [700] = "1d4ed8",
    [800] = "1e40af",
    [900] = "1e3a8a",
    [950] = "172554",
  },

  indigo = {
    [50] = "eef2ff",
    [100] = "e0e7ff",
    [200] = "c7d2fe",
    [300] = "a5b4fc",
    [400] = "818cf8",
    [500] = "6366f1",
    [600] = "4f46e5",
    [700] = "4338ca",
    [800] = "3730a3",
    [900] = "312e81",
    [950] = "1e1b4b",
  },

  violet = {
    [50] = "f5f3ff",
    [100] = "ede9fe",
    [200] = "ddd6fe",
    [300] = "c4b5fd",
    [400] = "a78bfa",
    [500] = "8b5cf6",
    [600] = "7c3aed",
    [700] = "6d28d9",
    [800] = "5b21b6",
    [900] = "4c1d95",
    [950] = "2e1065",
  },

  purple = {
    [50] = "faf5ff",
    [100] = "f3e8ff",
    [200] = "e9d5ff",
    [300] = "d8b4fe",
    [400] = "c084fc",
    [500] = "a855f7",
    [600] = "9333ea",
    [700] = "7e22ce",
    [800] = "6b21a8",
    [900] = "581c87",
    [950] = "3b0764",
  },

  fuchsia = {
    [50] = "fdf4ff",
    [100] = "fae8ff",
    [200] = "f5d0fe",
    [300] = "f0abfc",
    [400] = "e879f9",
    [500] = "d946ef",
    [600] = "c026d3",
    [700] = "a21caf",
    [800] = "86198f",
    [900] = "701a75",
    [950] = "4a044e",
  },

  pink = {
    [50] = "fdf2f8",
    [100] = "fce7f3",
    [200] = "fbcfe8",
    [300] = "f9a8d4",
    [400] = "f472b6",
    [500] = "ec4899",
    [600] = "db2777",
    [700] = "be185d",
    [800] = "9d174d",
    [900] = "831843",
    [950] = "500724",
  },

  rose = {
    [50] = "fff1f2",
    [100] = "ffe4e6",
    [200] = "fecdd3",
    [300] = "fda4af",
    [400] = "fb7185",
    [500] = "f43f5e",
    [600] = "e11d48",
    [700] = "be123c",
    [800] = "9f1239",
    [900] = "881337",
    [950] = "4c0519",
  },
}

local function setup_hipatterns()
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      M.hl = {}
    end,
  })

  local hi = require("mini.hipatterns")

  hi.setup({
    highlighters = {
      hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
      shorthand = {
        pattern = "()#%x%x%x()%f[^%x%w]",
        group = function(_, _, data)
          ---@type string
          local match = data.full_match
          local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
          local hex_color = "#" .. r .. r .. g .. g .. b .. b

          return hi.compute_hex_color_group(hex_color, "bg")
        end,
        extmark_opts = { priority = 2000 },
      },
      tailwind = {
        pattern = function()
          if
            not vim.tbl_contains({
              "astro",
              "css",
              "heex",
              "html",
              "html-eex",
              "javascript",
              "javascriptreact",
              "rust",
              "svelte",
              "typescript",
              "typescriptreact",
              "vue",
            }, vim.bo.filetype)
          then
            return
          end
          return "%f[%w:-]()[%w:-]+%-[a-z%-]+%-%d+()%f[^%w:-]"
        end,
        group = function(_, _, m)
          ---@type string
          local match = m.full_match
          ---@type string, number
          local color, shade = match:match("[%w-]+%-([a-z%-]+)%-(%d+)")
          shade = tonumber(shade)
          local bg = vim.tbl_get(colors, color, shade)
          if bg then
            local hl = "MiniHipatternsTailwind" .. color .. shade
            if not M.hl[hl] then
              M.hl[hl] = true
              local bg_shade = shade == 500 and 950 or shade < 500 and 900 or 100
              local fg = vim.tbl_get(colors, color, bg_shade)
              vim.api.nvim_set_hl(0, hl, { bg = "#" .. bg, fg = "#" .. fg })
            end
            return hl
          end
        end,
        extmark_opts = { priority = 2000 },
      },
    },
  })
end

local function setup_ai()
  local ai = require("mini.ai")

  ai.setup({
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
  })

  local wk_exists, wk = pcall(require, "which-key")

  if wk_exists then
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
  end
end

local function setup_comment()
  require("mini.comment").setup({
    options = {
      custom_commentstring = function()
        return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
      end,
    },
  })
end

local function setup_surround()
  require("mini.surround").setup({
    mappings = {
      add = "gsa",
      delete = "gsd",
      find = "gsf",
      find_left = "gsF",
      highlight = "gsh",
      replace = "gsr",
      update_n_lines = "gsn",
    },
  })
end

local function setup_snippets()
  local snippets = require("mini.snippets")

  local gen_loader = snippets.gen_loader

  snippets.setup({
    snippets = {
      gen_loader.from_lang(),
    },
    mappings = {
      expand = "",
      jump_next = "",
      jump_prev = "",
      stop = "",
    },
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniSnippetsSessionJump",
    callback = function(args)
      if args.data.tabstop_to == "0" then
        MiniSnippets.session.stop()
      end
    end,
  })
end

local function setup_move()
  local move = require("mini.move")
  move.setup({
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
  })
end

local function setup_diff()
  local diff = require("mini.diff")

  diff.setup({
    view = {
      style = "sign",
      signs = {
        add = "▎",
        change = "▎",
        delete = "",
      },
    },
  })

  vim.keymap.set("n", "<leader>go", function()
    diff.toggle_overlay(0)
  end, {
    desc = "Toggle mini.diff overlay",
    noremap = true,
    silent = true,
  })
end

local function setup_files()
  vim.keymap.set("n", "<leader>e", function()
    require("mini.files").open(vim.uv.cwd(), true)
  end, {
    desc = "Open mini.files",
    noremap = true,
    silent = true,
  })

  vim.keymap.set("n", "<leader>E", function()
    require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
  end, {
    desc = "Open mini.files in current file directory",
    noremap = true,
    silent = true,
  })

  local files = require("mini.files")

  files.setup({
    windows = {
      preview = true,
      width_focus = 30,
      width_preview = 50,
    },
    options = {
      use_as_default_explorer = true,
    },
    mappings = {
      close = "q",
      go_in = "L",
      go_in_plus = "l",
      go_out = "H",
      go_out_plus = "h",
      mark_goto = "'",
      mark_set = "m",
      reset = "<BS>",
      reveal_cwd = "@",
      show_help = "g?",
      synchronize = "=",
      trim_left = "<",
      trim_right = ">",
    },
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesActionRename",
    callback = function(event)
      Snacks.rename.on_rename_file(event.data.from, event.data.to)
    end,
  })
end

function M.config()
  if not vim.g.vscode then
    setup_starter()
    setup_icons()
    setup_autopair()
    setup_cursorword()
    setup_hipatterns()
    setup_snippets()
    setup_diff()
    setup_files()
  end
  setup_surround()
  setup_ai()
  setup_comment()
  setup_move()
end

return M
