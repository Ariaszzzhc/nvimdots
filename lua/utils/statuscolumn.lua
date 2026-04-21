-- Adapted from folke/snacks.nvim statuscolumn (Apache-2.0).
local M = {}

local defaults = {
  left = { "mark", "sign" },
  right = { "fold", "git" },
  folds = {
    open = false,
    git_hl = false,
  },
  git = {
    patterns = { "GitSign", "MiniDiffSign" },
  },
  refresh = 50,
}

local config = vim.deepcopy(defaults)
local did_setup = false
local sign_cache = {}
local cache = {}
local icon_cache = {}

local function merge_config(opts)
  config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
end

local function clear_cache()
  sign_cache = {}
  cache = {}
end

local function wanted_key(wanted)
  local ret = {}
  for _, key in ipairs({ "mark", "sign", "fold", "git" }) do
    if wanted[key] then
      ret[#ret + 1] = key
    end
  end
  return table.concat(ret, ",")
end

local function is_git_sign(name)
  for _, pattern in ipairs(config.git.patterns) do
    if name:find(pattern) then
      return true
    end
  end
  return false
end

local function fold_info(lnum)
  local level = vim.fn.foldlevel(lnum)
  if level == 0 then
    return
  end

  local closed = vim.fn.foldclosed(lnum)
  if closed == lnum then
    return {
      level = level,
      start = lnum,
      lines = vim.fn.foldclosedend(lnum) - lnum + 1,
    }
  end

  local previous = lnum > 1 and vim.fn.foldlevel(lnum - 1) or 0
  return {
    level = level,
    start = level > previous and lnum or 0,
    lines = 0,
  }
end

local function add_legacy_signs(buf, wanted, signs)
  if vim.fn.has("nvim-0.10") == 1 then
    return
  end

  local placed = vim.fn.sign_getplaced(buf, { group = "*" })[1]
  if placed == nil then
    return
  end

  for _, sign in ipairs(placed.signs) do
    local defined = vim.fn.sign_getdefined(sign.name)[1]
    if defined ~= nil then
      defined.priority = sign.priority
      defined.type = is_git_sign(sign.name) and "git" or "sign"
      if wanted[defined.type] then
        signs[sign.lnum] = signs[sign.lnum] or {}
        signs[sign.lnum][#signs[sign.lnum] + 1] = defined
      end
    end
  end
end

local function add_extmark_signs(buf, wanted, signs)
  local extmarks = vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, {
    details = true,
    type = "sign",
  })

  for _, extmark in ipairs(extmarks) do
    local details = extmark[4]
    local name = details.sign_hl_group or details.sign_name or ""
    local sign = {
      name = name,
      type = is_git_sign(name) and "git" or "sign",
      text = details.sign_text,
      texthl = details.sign_hl_group,
      priority = details.priority,
    }

    if wanted[sign.type] then
      local lnum = extmark[2] + 1
      signs[lnum] = signs[lnum] or {}
      signs[lnum][#signs[lnum] + 1] = sign
    end
  end
end

local function add_marks(buf, wanted, signs)
  if not wanted.mark then
    return
  end

  local marks = vim.fn.getmarklist(buf)
  vim.list_extend(marks, vim.fn.getmarklist())

  for _, mark in ipairs(marks) do
    if mark.pos[1] == buf and mark.mark:match("[a-zA-Z]") then
      local lnum = mark.pos[2]
      signs[lnum] = signs[lnum] or {}
      signs[lnum][#signs[lnum] + 1] = {
        text = mark.mark:sub(2),
        texthl = "ConfigStatusColumnMark",
        type = "mark",
      }
    end
  end
end

local function buf_signs(buf, wanted)
  local key = ("%d:%s"):format(buf, wanted_key(wanted))
  if sign_cache[key] ~= nil then
    return sign_cache[key]
  end

  local signs = {}
  if wanted.git or wanted.sign then
    add_legacy_signs(buf, wanted, signs)
    add_extmark_signs(buf, wanted, signs)
  end
  add_marks(buf, wanted, signs)

  sign_cache[key] = signs
  return signs
end

local function line_signs(win, buf, lnum, wanted)
  local signs = vim.deepcopy(buf_signs(buf, wanted)[lnum] or {})

  if wanted.fold then
    local info = fold_info(lnum)
    if info and info.level > 0 then
      local fillchars = vim.opt.fillchars:get()
      if info.lines > 0 then
        signs[#signs + 1] = {
          text = fillchars.foldclose or "",
          texthl = "Folded",
          type = "fold",
        }
      elseif config.folds.open and info.start == lnum then
        signs[#signs + 1] = {
          text = fillchars.foldopen or "",
          type = "fold",
        }
      end
    end
  end

  table.sort(signs, function(a, b)
    return (a.priority or 0) > (b.priority or 0)
  end)

  return signs
end

local function icon(sign)
  if sign == nil then
    return " "
  end

  local key = (sign.text or "") .. (sign.texthl or "")
  if icon_cache[key] ~= nil then
    return icon_cache[key]
  end

  local text = vim.fn.strcharpart(sign.text or "", 0, 2)
  text = text .. string.rep(" ", 2 - vim.fn.strchars(text))
  icon_cache[key] = sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text

  return icon_cache[key]
end

local function component_list(value, win, buf, lnum)
  if type(value) == "function" then
    return value(win, buf, lnum)
  end
  return value
end

local function first_sign(signs_by_type, types)
  for _, type in ipairs(types) do
    if signs_by_type[type] ~= nil then
      return signs_by_type[type]
    end
  end
end

function M._get()
  local win = vim.g.statusline_winid or vim.api.nvim_get_current_win()
  if not vim.api.nvim_win_is_valid(win) then
    return ""
  end

  local buf = vim.api.nvim_win_get_buf(win)
  local number = vim.wo[win].number
  local relativenumber = vim.wo[win].relativenumber
  local show_signs = vim.v.virtnum == 0 and vim.wo[win].signcolumn ~= "no"
  local show_folds = vim.v.virtnum == 0 and vim.wo[win].foldcolumn ~= "0"

  if not (show_signs or number or relativenumber) then
    return ""
  end

  local left_components = component_list(config.left, win, buf, vim.v.lnum)
  local right_components = component_list(config.right, win, buf, vim.v.lnum)
  local wanted = { sign = show_signs }

  for _, component in ipairs(left_components) do
    wanted[component] = wanted[component] ~= false
  end
  for _, component in ipairs(right_components) do
    wanted[component] = wanted[component] ~= false
  end

  local components = { "", "", "" }

  if (number or relativenumber) and vim.v.virtnum == 0 then
    local lnum = vim.v.lnum
    if relativenumber and not (number and vim.v.relnum == 0) then
      lnum = vim.v.relnum
    end
    components[2] = "%=" .. lnum .. " "
  end

  if show_signs or show_folds then
    local signs = line_signs(win, buf, vim.v.lnum, wanted)
    if #signs > 0 then
      local signs_by_type = {}
      for _, sign in ipairs(signs) do
        signs_by_type[sign.type] = signs_by_type[sign.type] or sign
      end

      local left = first_sign(signs_by_type, left_components)
      local right = first_sign(signs_by_type, right_components)
      if config.folds.git_hl then
        local git = signs_by_type.git
        if git and left and left.type == "fold" then
          left.texthl = git.texthl
        end
        if git and right and right.type == "fold" then
          right.texthl = git.texthl
        end
      end

      components[1] = icon(left)
      components[3] = icon(right)
    else
      components[1] = " "
      components[3] = " "
    end
  end

  if vim.b[buf].statuscolumn_left == false then
    components[1] = ""
  end
  if vim.b[buf].statuscolumn_right == false then
    components[3] = ""
  end

  return "%@v:lua.require'utils.statuscolumn'.click_fold@" .. table.concat(components, "") .. "%T"
end

function M.get()
  local win = vim.g.statusline_winid or vim.api.nvim_get_current_win()
  if not vim.api.nvim_win_is_valid(win) then
    return ""
  end

  local buf = vim.api.nvim_win_get_buf(win)
  local key = ("%d:%d:%d:%d:%d"):format(win, buf, vim.v.lnum, vim.v.virtnum ~= 0 and 1 or 0, vim.v.relnum)
  if cache[key] ~= nil then
    return cache[key]
  end

  local ok, ret = pcall(M._get)
  if not ok then
    return ""
  end

  cache[key] = ret
  return ret
end

function M.click_fold()
  local pos = vim.fn.getmousepos()
  if pos.winid == 0 or not vim.api.nvim_win_is_valid(pos.winid) then
    return
  end

  vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 1 })
  vim.api.nvim_win_call(pos.winid, function()
    if vim.fn.foldlevel(pos.line) > 0 then
      vim.cmd("normal! za")
    end
  end)
end

function M.setup(opts)
  merge_config(opts)

  if did_setup then
    clear_cache()
    return
  end

  did_setup = true
  vim.api.nvim_set_hl(0, "ConfigStatusColumnMark", { link = "DiagnosticHint", default = true })
  vim.o.statuscolumn = "%!v:lua.require'utils.statuscolumn'.get()"

  local timer = assert((vim.uv or vim.loop).new_timer())
  timer:start(config.refresh, config.refresh, clear_cache)
  if timer.unref then
    timer:unref()
  end
end

M.setup()

return M
