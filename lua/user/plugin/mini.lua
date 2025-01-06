local M = {
  'echasnovski/mini.nvim',
  version = false,
}

M.config = function()
  -- setup pairs
  require("mini.pairs").setup()

  -- setup highlighters
  require("mini.hipatterns").setup()

  -- setup surround
  require("mini.surround").setup()

  -- setup fuzzy
  require("mini.fuzzy").setup()

  -- setup starters
  -- local starter = require("mini.starter")
  --
  -- starter.setup({
  --   autoopen = true,
  --   evaluate_single = true,
  --   header = table.concat({
  --     [[                               __                ]],
  --     [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
  --     [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
  --     [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
  --     [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
  --     [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
  --   }, "\n"),
  --   footer = function()
  --     local stats = require("lazy").stats()
  --     local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
  --     return "Loaded " .. stats.count .. " plugins in " .. ms .. "ms"
  --   end,
  --   items = {
  --     {
  --       name = "Find file",
  --       action = ":Telescope find_files <CR>",
  --       section = "Actions",
  --     },
  --     {
  --       name = "New file",
  --       action = ":ene <BAR> startinsert <CR>",
  --       section = "Actions",
  --     },
  --     {
  --
  --       name = "Recent files",
  --       action = ":Telescope oldfiles <CR>",
  --       section = "Actions",
  --     },
  --     {
  --       name = "Find text",
  --       action = ":Telescope live_grep <CR>",
  --       section = "Actions",
  --     },
  --     {
  --       name = "Config",
  --       action = ":e ~/.config/nvim/init.lua <CR>",
  --       section = "Actions",
  --     },
  --     {
  --       name = "Quit",
  --       action = ":qa<CR>",
  --       section = "Actions",
  --     },
  --   },
  --   showtabline = false,
  --   content_hooks = {
  --     starter.gen_hook.aligning("center", "center"),
  --   },
  -- })
  --
  -- vim.api.nvim_create_autocmd("User", {
  --   pattern = "MiniStarterOpened",
  --   callback = function()
  --     starter.refresh()
  --   end,
  -- })
end

return M
