local M = {}

---@private
---@alias LspWord {from:{[1]:number, [2]:number}, to:{[1]:number, [2]:number}} 1-0 indexed

---@class words.Config
local config = {
  debounce = 200, -- time in ms to wait before updating
  notify_jump = false, -- show a notification when jumping
  notify_end = true, -- show a notification when reaching the end
  foldopen = true, -- open folds after jumping
  jumplist = true, -- set jump point before jumping
  modes = { "n", "i", "c" }, -- modes to show references
}

M.enabled = false

local ns = vim.api.nvim_create_namespace("vim_lsp_references")
local ns2 = vim.api.nvim_create_namespace("nvim.lsp.references")
local timer = (vim.uv or vim.loop).new_timer()

function M.enable()
  if M.enabled then
    return
  end
  M.enabled = true
  local group = vim.api.nvim_create_augroup("enable_words", { clear = true })

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "ModeChanged" }, {
    group = group,
    callback = function()
      if not M.is_enabled({ modes = true }) then
        M.clear()
        return
      end
      if not ({ M.get() })[2] then
        M.update()
      end
    end,
  })
end

function M.disable()
  if not M.enabled then
    return
  end
  M.enabled = false
  pcall(vim.api.nvim_del_augroup_by_name, "enable_words")
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    vim.api.nvim_buf_clear_namespace(buf, ns2, 0, -1)
  end
end

function M.toggle()
  if M.enabled then
    M.disable()
  else
    M.enable()
    M.update()
  end

  vim.notify(("Words %s"):format(M.enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end

function M.clear()
  vim.lsp.buf.clear_references()
end

---@private
function M.update()
  local buf = vim.api.nvim_get_current_buf()
  if timer ~= nil then
    timer:start(config.debounce, 0, function()
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_call(buf, function()
            if not M.is_enabled({ modes = true }) then
              M.clear()
              return
            end
            M.clear()
            vim.lsp.buf.document_highlight()
          end)
        end
      end)
    end)
  end
end

---@param opts? number|{buf?:number, modes:boolean} if modes is true, also check if the current mode is enabled
function M.is_enabled(opts)
  if not M.enabled then
    return false
  end
  opts = type(opts) == "number" and { buf = opts } or opts or {}

  if opts.modes then
    local mode = vim.api.nvim_get_mode().mode:lower()
    mode = mode:gsub("\22", "v"):gsub("\19", "s")
    mode = mode:sub(1, 2) == "no" and "o" or mode
    mode = mode:sub(1, 1):match("[ncitsvo]") or "n"
    if not vim.tbl_contains(config.modes, mode) then
      return false
    end
  end

  local buf = opts.buf or vim.api.nvim_get_current_buf()

  local clients = {} ---@type vim.lsp.Client[]
  if vim.fn.has("nvim-0.11") == 1 then
    clients = vim.lsp.get_clients({ bufnr = buf, method = "textDocument/documentHighlight" })
  else
    clients = vim.lsp.get_clients({ bufnr = buf })
    clients = vim.tbl_filter(function(client)
      return client.supports_method("textDocument/documentHighlight", { bufnr = buf })
    end, clients)
  end

  return #clients > 0
end

local function cursor_in_word(cursor, word)
  if cursor[1] < word.from[1] or cursor[1] > word.to[1] then
    return false
  end

  if word.from[1] == word.to[1] then
    return cursor[2] >= word.from[2] and cursor[2] < word.to[2]
  end

  if cursor[1] == word.from[1] then
    return cursor[2] >= word.from[2]
  end

  if cursor[1] == word.to[1] then
    return cursor[2] < word.to[2]
  end

  return true
end

---@private
---@return LspWord[] words, number? current
function M.get()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current, ret = nil, {} ---@type number?, LspWord[]
  local extmarks = {} ---@type vim.api.keyset.get_extmark_item[]
  vim.list_extend(extmarks, vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, { details = true }))
  vim.list_extend(extmarks, vim.api.nvim_buf_get_extmarks(0, ns2, 0, -1, { details = true }))
  for _, extmark in ipairs(extmarks) do
    local w = {
      from = { extmark[2] + 1, extmark[3] },
      to = { extmark[4].end_row + 1, extmark[4].end_col },
    }
    ret[#ret + 1] = w
  end

  table.sort(ret, function(a, b)
    if a.from[1] == b.from[1] then
      return a.from[2] < b.from[2]
    end
    return a.from[1] < b.from[1]
  end)

  for index, word in ipairs(ret) do
    if cursor_in_word(cursor, word) then
      current = index
      break
    end
  end

  return ret, current
end

---@param count? number
---@param cycle? boolean
function M.jump(count, cycle)
  count = count or 1
  local words, idx = M.get()
  if not idx then
    return
  end
  idx = idx + count
  if cycle then
    idx = (idx - 1) % #words + 1
  end
  local target = words[idx]
  if target then
    if config.jumplist then
      vim.cmd.normal({ "m`", bang = true })
    end
    vim.api.nvim_win_set_cursor(0, target.from)
    if config.notify_jump then
      vim.notify(("Reference [%d/%d]"):format(idx, #words), vim.log.levels.INFO)
    end
    if config.foldopen then
      vim.cmd.normal({ "zv", bang = true })
    end
  elseif config.notify_end then
    vim.notify("No more references", vim.log.levels.WARN)
  end
end

vim.keymap.set("n", "<leader>uw", M.toggle, { desc = "Toggle Words", silent = true })
M.enable()

return M
