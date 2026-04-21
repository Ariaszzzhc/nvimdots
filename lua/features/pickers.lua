local M = {}

local function fzf()
  return require("fzf-lua")
end

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO)
end

function M.run(command, opts)
  return function()
    fzf()[command](opts)
  end
end

function M.config_files()
  fzf().files({ cwd = vim.fn.stdpath("config") })
end

function M.grep_word()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    fzf().grep_visual()
  else
    fzf().grep_cword()
  end
end

function M.notifications()
  pcall(vim.cmd, "packadd nvim-notify")

  local ok, picker = pcall(require, "notify.integrations.fzf")
  if not ok then
    notify("nvim-notify fzf integration is unavailable", vim.log.levels.WARN)
    return
  end

  picker.open()
end

function M.projects()
  if vim.fn.executable("zoxide") == 1 then
    fzf().zoxide()
    return
  end

  fzf().files()
end

local function open_gh_item(kind, selected)
  local line = selected and selected[1]
  local number = line and line:match("#?(%d+)")
  if number == nil then
    return
  end

  vim.fn.jobstart({ "gh", kind, "view", number, "--web" }, { detach = true })
end

function M.gh(kind, state)
  return function()
    if vim.fn.executable("gh") == 0 then
      notify("gh executable is unavailable", vim.log.levels.WARN)
      return
    end

    local label = kind == "pr" and "Pull Requests" or "Issues"
    local cmd = ("gh %s list --state %s --limit 200"):format(kind, state or "open")

    fzf().fzf_exec(cmd, {
      prompt = label .. "> ",
      preview = ("gh %s view {1} --comments --color always"):format(kind),
      actions = {
        ["default"] = function(selected)
          open_gh_item(kind, selected)
        end,
      },
      fzf_opts = {
        ["--ansi"] = true,
        ["--no-multi"] = true,
      },
    })
  end
end

function M.icons()
  local icons = require("config.icons")
  local entries = {}

  local function collect(prefix, tbl)
    for key, value in pairs(tbl) do
      local name = prefix == "" and key or (prefix .. "." .. key)
      if type(value) == "string" then
        entries[#entries + 1] = value .. "\t" .. name
      elseif type(value) == "table" and type(value[1]) == "string" then
        entries[#entries + 1] = value[1] .. "\t" .. name
      elseif type(value) == "table" then
        collect(name, value)
      end
    end
  end

  collect("", icons)
  table.sort(entries)

  fzf().fzf_exec(entries, {
    prompt = "Icons> ",
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "2..",
    },
    actions = {
      ["default"] = function(selected)
        local icon = selected[1] and selected[1]:match("^(.-)\t")
        if icon == nil then
          return
        end

        vim.fn.setreg("+", icon)
        vim.fn.setreg('"', icon)
        notify(("Copied %s"):format(icon))
      end,
    },
  })
end

function M.plugin_specs()
  fzf().grep({
    prompt = "Plugin Specs> ",
    cwd = vim.fn.stdpath("config"),
    search = [[^\s*["'][A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+]],
    no_esc = true,
    rg_opts = [[--column --line-number --no-heading --color=always --smart-case -g lua/plugins/**/*.lua -e]],
  })
end

function M.todo(keywords)
  return function()
    pcall(vim.cmd, "packadd todo-comments.nvim")

    local ok, picker = pcall(require, "todo-comments.fzf")
    if not ok then
      notify("todo-comments fzf integration is unavailable", vim.log.levels.WARN)
      return
    end

    picker.todo({ keywords = keywords })
  end
end

return M
