-- Adapted from folke/snacks.nvim indent (Apache-2.0).
local M = {}

local defaults = {
  priority = 1,
  char = "│",
  hl = "ConfigIndent",
  only_current = false,
  filter = function(buf)
    return vim.bo[buf].buftype == ""
  end,
}

local config = vim.deepcopy(defaults)
local ns = vim.api.nvim_create_namespace("config_indent")
local cache_extmarks = {}
local states = {}
local has_repeat_linebreak = vim.fn.has("nvim-0.10.0") == 1

M.enabled = false

local function merge_config(opts)
  config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
end

local function get_hl(level)
  return type(config.hl) == "string" and config.hl or config.hl[(level - 1) % #config.hl + 1]
end

local function clear_state()
  cache_extmarks = {}
  states = {}
end

local function redraw()
  vim.schedule(function()
    vim.cmd("redraw!")
  end)
end

local function set_highlights()
  vim.api.nvim_set_hl(0, "ConfigIndent", { link = "NonText", default = true })
end

local function get_extmarks(indent, state)
  local key = table.concat({
    indent,
    state.leftcol,
    state.shiftwidth,
    state.breakindent and "bi" or "",
  }, ":")

  if cache_extmarks[key] ~= nil then
    return cache_extmarks[key]
  end

  local shiftwidth = state.shiftwidth
  local levels = math.floor(indent / shiftwidth)
  local marks = {}

  for level = 1, levels do
    local col = (level - 1) * shiftwidth - state.leftcol
    if col >= 0 then
      marks[#marks + 1] = {
        virt_text = { { config.char, get_hl(level) } },
        virt_text_pos = "overlay",
        virt_text_win_col = col,
        hl_mode = "combine",
        priority = config.priority,
        ephemeral = true,
        virt_text_repeat_linebreak = has_repeat_linebreak and state.breakindent or nil,
      }
    end
  end

  cache_extmarks[key] = marks
  return marks
end

local function get_state(win, buf, top, bottom)
  local previous = states[win]
  local changedtick = vim.b[buf].changedtick
  if not (previous and previous.buf == buf and previous.changedtick == changedtick) then
    previous = nil
  end

  local ok, view = pcall(vim.api.nvim_win_call, win, vim.fn.winsaveview)
  local shiftwidth = vim.bo[buf].shiftwidth
  shiftwidth = shiftwidth == 0 and vim.bo[buf].tabstop or shiftwidth

  local state = {
    win = win,
    buf = buf,
    changedtick = changedtick,
    is_current = win == vim.api.nvim_get_current_win(),
    top = top,
    bottom = bottom,
    leftcol = ok and view.leftcol or 0,
    shiftwidth = shiftwidth,
    indents = previous and previous.indents or { [0] = 0 },
    blanks = previous and previous.blanks or {},
    breakindent = vim.wo[win].breakindent and vim.wo[win].wrap,
  }

  states[win] = state
  return state
end

local function line_indent(lnum, state)
  local indent = state.indents[lnum]
  if indent ~= nil then
    return indent
  end

  local next = vim.fn.nextnonblank(lnum)
  if next ~= lnum then
    state.blanks[lnum] = true

    local previous = vim.fn.prevnonblank(lnum)
    state.indents[previous] = state.indents[previous] or vim.fn.indent(previous)
    state.indents[next] = state.indents[next] or vim.fn.indent(next)

    indent = math.min(state.indents[previous], state.indents[next])
    if state.indents[previous] ~= state.indents[next] and indent > 0 then
      indent = indent + state.shiftwidth
    end
  else
    indent = vim.fn.indent(lnum)
  end

  state.indents[lnum] = indent
  return indent
end

function M.on_win(win, buf, top, bottom)
  local state = get_state(win, buf, top, bottom)
  if config.only_current and not state.is_current then
    return
  end

  vim.api.nvim_buf_call(buf, function()
    local parent_indent
    local current_indent

    for lnum = state.top, state.bottom do
      local indent = line_indent(lnum, state)

      if indent ~= current_indent then
        parent_indent = current_indent or indent
        current_indent = indent
      end

      indent = math.min(indent, parent_indent + state.shiftwidth)
      if indent > 0 then
        for _, opts in ipairs(get_extmarks(indent, state)) do
          vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, 0, opts)
        end
      end
    end
  end)
end

function M.enable(opts)
  if opts ~= nil then
    merge_config(opts)
  end

  if M.enabled then
    return
  end

  M.enabled = true

  vim.api.nvim_set_decoration_provider(ns, {
    on_win = function(_, win, buf, top, bottom)
      if not M.enabled then
        return
      end
      if not vim.api.nvim_win_is_valid(win) or not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      if not config.filter(buf, win) then
        return
      end

      M.on_win(win, buf, top + 1, bottom + 1)
    end,
  })

  local group = vim.api.nvim_create_augroup("config_indent", { clear = true })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      set_highlights()
      cache_extmarks = {}
    end,
  })

  vim.api.nvim_create_autocmd({ "WinClosed", "BufDelete", "BufWipeout" }, {
    group = group,
    callback = function()
      for win in pairs(states) do
        if not vim.api.nvim_win_is_valid(win) then
          states[win] = nil
        end
      end
    end,
  })

  vim.api.nvim_create_autocmd("OptionSet", {
    group = group,
    pattern = { "shiftwidth", "tabstop", "breakindent", "wrap" },
    callback = function()
      clear_state()
      redraw()
    end,
  })

  redraw()
end

function M.disable()
  if not M.enabled then
    return
  end

  M.enabled = false
  pcall(vim.api.nvim_del_augroup_by_name, "config_indent")
  clear_state()
  redraw()
end

function M.toggle()
  if M.enabled then
    M.disable()
  else
    M.enable()
  end

  vim.notify(("Indent guides %s"):format(M.enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end

function M.setup(opts)
  merge_config(opts)
  if M.enabled then
    clear_state()
    redraw()
  else
    M.enable()
  end
end

set_highlights()
vim.keymap.set("n", "<leader>ug", M.toggle, { desc = "Toggle Indent Guides", silent = true })

return M
