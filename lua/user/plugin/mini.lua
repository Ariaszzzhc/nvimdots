local function add_mini(item)
  table.insert(LAZY_PLUGIN_SPEC, item)
end

add_mini({
  "echasnovski/mini.starter",
  version = false,
  event = "VimEnter",
  config = function()
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

    local builtin = require("telescope.builtin")

    local opts = {
      header = logo,
      evaluate_single = true,
      items = {
        new_section("Find file", builtin.find_files, "Picker"),
        new_section("Recent files", builtin.oldfiles, "Picker"),
        new_section("Find text", builtin.live_grep, "Picker"),
        new_section("New file", "ene | startinsert", "Built-in"),
        new_section("Quit", "qa", "Built-in"),
        new_section("Config", function()
          builtin.find_files({
            cwd = vim.fn.stdpath("config"),
          })
        end, "Config"),
        new_section("Update", function()
          vim.cmd [[ Lazy Update ]]
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
  end,
})

add_mini({
  "echasnovski/mini.indentscope",
  version = false,
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  opts = function()
    return {
      symbol = "│",
      options = { try_as_border = true },
    }
  end,
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "Trouble",
        "help",
        "lazy",
        "notify",
        "trouble",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
})

add_mini({
  "echasnovski/mini.animate",
  event = "VeryLazy",
  cond = vim.g.neovide == nil,
  config = function()
    require("mini.animate").setup()
  end,
})

add_mini({
  "echasnovski/mini.notify",
  event = "VimEnter",
  init = function()
    vim.notify = require("mini.notify").make_notify()
  end,
  config = function()
    require("mini.notify").setup({
      lsp_progress = {
        enable = false,
      },
      window = {
        config = {
          border = "rounded",
        },
      },
    })
  end,
})

add_mini({
  "echasnovski/mini.pairs",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  config = function()
    require("mini.pairs").setup()
  end,
})

add_mini({
  "echasnovski/mini.hipatterns",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  config = function()
    require("mini.hipatterns").setup()
  end,
})

add_mini({
  "echasnovski/mini.surround",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  config = function()
    require("mini.surround").setup()
  end,
})

add_mini({
  "echasnovski/mini.fuzzy",
  event = "VimEnter",
  config = function()
    require("mini.fuzzy").setup()
  end,
})

add_mini({
  "echasnovski/mini.icons",
  event = "VimEnter",
  config = function()
    local mini_icons = require("mini.icons")
    mini_icons.setup()

    mini_icons.mock_nvim_web_devicons()
  end,
})
