local plugin = require("config.plugin")

local lazygit_terms = {}

local function lazygit_icon_config()
  return vim.fs.joinpath(vim.fn.stdpath("config"), "lazygit", "config.yml")
end

local function existing_lazygit_configs()
  local candidates = {
    vim.env.APPDATA and vim.fs.joinpath(vim.env.APPDATA, "lazygit", "config.yml"),
    vim.env.LOCALAPPDATA and vim.fs.joinpath(vim.env.LOCALAPPDATA, "lazygit", "config.yml"),
    vim.fs.joinpath(vim.fn.expand("~"), ".config", "lazygit", "config.yml"),
  }
  local configs = {}

  for _, path in ipairs(candidates) do
    if path ~= nil and vim.uv.fs_stat(path) ~= nil then
      table.insert(configs, path)
    end
  end

  table.insert(configs, lazygit_icon_config())
  return table.concat(configs, ",")
end

local function buffer_dir()
  local name = vim.api.nvim_buf_get_name(0)
  if name ~= "" then
    return vim.fs.dirname(name)
  end

  return vim.uv.cwd() or vim.fn.getcwd()
end

local function git_root()
  local git_dir = vim.fs.find(".git", {
    path = buffer_dir(),
    upward = true,
  })[1]

  if git_dir ~= nil then
    return vim.fs.dirname(git_dir)
  end

  return vim.fn.getcwd()
end

local function terminal_size(term)
  if term.direction == "horizontal" then
    return 15
  end

  if term.direction == "vertical" then
    return math.floor(vim.o.columns * 0.4)
  end
end

local function float_width()
  return math.floor(vim.o.columns * 0.85)
end

local function float_height()
  return math.floor(vim.o.lines * 0.8)
end

local function set_terminal_keymaps(term)
  local function map(lhs, rhs, desc)
    vim.keymap.set("t", lhs, rhs, {
      buffer = term.bufnr,
      desc = desc,
      silent = true,
    })
  end

  map("<esc><esc>", [[<C-\><C-n>]], "Exit terminal mode")
  map("<C-h>", [[<Cmd>wincmd h<CR>]], "Go to left window")
  map("<C-j>", [[<Cmd>wincmd j<CR>]], "Go to lower window")
  map("<C-k>", [[<Cmd>wincmd k<CR>]], "Go to upper window")
  map("<C-l>", [[<Cmd>wincmd l<CR>]], "Go to right window")
  map("<C-w>", [[<C-\><C-n><C-w>]], "Start window command")
end

local function lazygit()
  if vim.fn.executable("lazygit") == 0 then
    vim.notify("lazygit executable not found on PATH", vim.log.levels.WARN)
    return
  end

  local root = git_root()
  local Terminal = require("toggleterm.terminal").Terminal

  lazygit_terms[root] = lazygit_terms[root]
    or Terminal:new({
      cmd = "lazygit",
      dir = root,
      direction = "float",
      display_name = "lazygit",
      hidden = true,
      close_on_exit = true,
      env = {
        LG_CONFIG_FILE = existing_lazygit_configs(),
      },
      float_opts = {
        border = "single",
      },
    })

  lazygit_terms[root]:toggle()
end

plugin.add({
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    opts = {
      size = terminal_size,
      direction = "float",
      hide_numbers = true,
      start_in_insert = true,
      persist_size = true,
      persist_mode = true,
      close_on_exit = true,
      auto_scroll = true,
      float_opts = {
        border = "single",
        width = float_width,
        height = float_height,
        title_pos = "center",
      },
      on_open = set_terminal_keymaps,
    },
    config = function(opts)
      require("toggleterm").setup(opts)

      vim.api.nvim_create_user_command("LazyGit", lazygit, {
        desc = "Open lazygit in a floating terminal",
      })
    end,
    keys = {
      { "<leader>tt", "<Cmd>ToggleTerm direction=float<CR>", desc = "Toggle floating terminal" },
      { "<leader>th", "<Cmd>ToggleTerm direction=horizontal<CR>", desc = "Toggle horizontal terminal" },
      { "<leader>tv", "<Cmd>ToggleTerm direction=vertical<CR>", desc = "Toggle vertical terminal" },
      { "<leader>ts", "<Cmd>TermSelect<CR>", desc = "Select terminal" },
      { "<leader>gg", lazygit, desc = "LazyGit" },
    },
  },
})
