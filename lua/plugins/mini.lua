local M = {
  "echasnovski/mini.nvim",
  version = false,
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "Trouble",
        "help",
        "lazy",
        "notify",
        "trouble",
        "ministarter",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
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
        vim.cmd([[ Lazy Update ]])
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

local function setup_statusline()
  local statusline = require("mini.statusline")
  local icons = require("configs.icons")
  local trouble = require("trouble")
  local snacks = require("snacks")

  local symbols = trouble.statusline({
    mode = "symbols",
    title = false,
    filter = { range = true },
    format = "{kind_icon}{symbol.name:Normal}",
  })

  statusline.setup({
    content = {
      inactive = nil,
      active = function()
        local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
        local git = statusline.section_git({ trunc_width = 40 })
        local diff = statusline.section_diff({
          trunc_width = 75,
          {

            icon = icons.git.Diff,
          },
        })
        local diagnostics = statusline.section_diagnostics({
          trunc_width = 75,
          signs = {
            ERROR = icons.diagnostics.Error,
            WARN = icons.diagnostics.Warning,
            INFO = icons.diagnostics.Information,
            HINT = icons.diagnostics.Hint,
          },
        })
        local lsp = statusline.section_lsp({ trunc_width = 75 })
        local filename = statusline.section_filename({ trunc_width = 140 })
        local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
        local location = statusline.section_location({ trunc_width = 75 })
        local search = statusline.section_searchcount({ trunc_width = 75 })

        local function get_date()
          return " " .. os.date("%R")
        end

        return statusline.combine_groups({
          { hl = mode_hl, strings = { mode } },
          {
            strings = { git },
          },
          {
            hl = "MiniStatuslineDevinfo",
            strings = { diagnostics },
          },
          {
            -- hl = "lualine_c_normal",
            strings = {
              symbols.get(),
            },
          },
          {
            strings = {
              snacks.profiler.running() and snacks.profiler.status()[1]() or "",
              diff,
            },
          },
          {
            strings = {
              location,
            },
          },
          {
            strings = {
              get_date(),
            },
          },
        })
      end,
    },
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
  local mini_icons = require("mini.icons")
  mini_icons.setup()

  mini_icons.mock_nvim_web_devicons()
end

local function setup_indentscope()
  require("mini.indentscope").setup({
    symbol = "│",
    options = { try_as_border = true },
  })
end

local function setup_cursorword()
  require("mini.cursorword").setup()
end

local function setup_tabline()
  local tabline = require("mini.tabline")

  tabline.setup({
    show_icons = true,
    format = function(bufnr, label)
      local suffix = vim.bo[bufnr].modified and " " or ""
      return tabline.default_format(bufnr, label) .. suffix
    end,
  })
end

function M.config()
  setup_starter()
  setup_icons()
  setup_autopair()
  setup_indentscope()
  setup_statusline()
  setup_tabline()
  setup_cursorword()
end

return M
