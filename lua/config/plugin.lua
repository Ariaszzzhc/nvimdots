local M = {}

local augroup = vim.api.nvim_create_augroup("PluginInit", { clear = true })
local registry = {}
local plugin_order = {}
local disabled_plugins = {}
local flushed = false
local build_hook_registered = false
local very_lazy_dispatched = false
local very_lazy_scheduled = false

local function dispatch_very_lazy()
  if very_lazy_dispatched then
    return
  end

  very_lazy_dispatched = true
  vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy", modeline = false })
end

local function schedule_very_lazy()
  if very_lazy_scheduled or very_lazy_dispatched then
    return
  end

  very_lazy_scheduled = true

  local defer = function()
    vim.defer_fn(dispatch_very_lazy, 0)
  end

  if vim.v.vim_did_enter == 1 then
    dispatch_very_lazy()
  else
    vim.api.nvim_create_autocmd("VimEnter", {
      group = augroup,
      once = true,
      callback = defer,
    })
  end
end

local function normalize_src(src)
  if type(src) ~= "string" or src == "" then
    error("plugin spec requires a non-empty src", 3)
  end

  if src:match("^gh:") then
    return "https://github.com/" .. src:sub(4)
  end

  if src:match("^[%w_.-]+/[%w_.-]+$") then
    return "https://github.com/" .. src
  end

  return src
end

local function infer_name(src)
  return (src:gsub("%.git$", ""):match("([^/]+)$"))
end

local function infer_main(name)
  return (name:gsub("%.nvim$", ""):gsub("%.lua$", ""):gsub("%.vim$", ""))
end

local function normalize_spec(spec)
  if type(spec) == "string" then
    spec = { spec }
  elseif type(spec) ~= "table" then
    error("plugin spec must be a string or table", 3)
  end

  local src = normalize_src(spec.src or spec.source or spec[1])
  local name = spec.name or infer_name(src)
  local plugin = vim.tbl_extend("force", spec, {
    key = src,
    raw = spec,
    src = src,
    name = name,
  })

  return plugin
end

local function is_disabled(spec)
  return spec.disabled or disabled_plugins[spec.key] == true
end

local function pack_spec(spec)
  return {
    src = spec.src,
    name = spec.name,
    version = spec.version,
  }
end

local function notify_error(name, phase, err)
  vim.schedule(function()
    vim.notify(("plugin %s failed during %s:\n%s"):format(name, phase, err), vim.log.levels.ERROR)
  end)
end

local function load_plugin(name)
  local ok, err = pcall(vim.cmd, "packadd " .. vim.fn.fnameescape(name))
  if not ok then
    notify_error(name, "packadd", err)
  end
  return ok
end

local init_plugin

local function with_plugin_cwd(path, fn)
  local cwd = vim.fn.getcwd()
  local cd_ok, cd_err = pcall(vim.cmd, "silent noautocmd cd " .. vim.fn.fnameescape(path))
  if not cd_ok then
    error(cd_err)
  end

  local ok, err = pcall(fn)
  pcall(vim.cmd, "silent noautocmd cd " .. vim.fn.fnameescape(cwd))

  if not ok then
    error(err)
  end
end

local function build_file(path, file)
  if file:match("^/") then
    return file
  end

  return vim.fs.joinpath(path, file)
end

local function lua_build_file(path, file)
  local full_path = build_file(path, file)
  local chunk, err = loadfile(full_path)
  if chunk == nil then
    error(err)
  end

  with_plugin_cwd(path, chunk)
end

local function shell_build(path, command)
  local result = vim.system({ vim.o.shell, vim.o.shellcmdflag, command }, { cwd = path, text = true }):wait()

  if result.code ~= 0 then
    error(("shell command failed: %s\n%s%s"):format(command, result.stderr or "", result.stdout or ""))
  end
end

local function run_build_step(spec, path, step)
  if type(step) == "function" then
    with_plugin_cwd(path, step)
    return
  end

  if type(step) ~= "string" then
    error(("plugin %s build step must be a function or string"):format(spec.name))
  end

  if step:match("%.lua$") then
    lua_build_file(path, step)
    return
  end

  if step:sub(1, 1) == ":" then
    with_plugin_cwd(path, function()
      if not load_plugin(spec.name) then
        error(("failed to load plugin %s before command build"):format(spec.name))
      end

      vim.cmd(step:sub(2))
    end)
    return
  end

  shell_build(path, step)
end

local function build_steps(spec, path)
  if spec.build == nil then
    local fallback = vim.fs.joinpath(path, "build.lua")
    if vim.uv.fs_stat(fallback) ~= nil then
      return { "build.lua" }
    end

    return {}
  end

  if type(spec.build) == "function" or type(spec.build) == "string" then
    return { spec.build }
  end

  if type(spec.build) == "table" and vim.islist(spec.build) then
    return spec.build
  end

  error(("plugin %s build must be a function, string, or list"):format(spec.name))
end

local function run_build(spec, path)
  local ok, err = pcall(function()
    for _, step in ipairs(build_steps(spec, path)) do
      run_build_step(spec, path, step)
    end
  end)

  if not ok then
    notify_error(spec.name, "build", err)
  end
end

local function resolve_opts(spec)
  if vim.tbl_isempty(spec.opts_fragments) then
    return nil
  end

  local opts = {}

  for _, fragment in ipairs(spec.opts_fragments) do
    if type(fragment) == "function" then
      opts = fragment(opts)
    elseif fragment ~= nil then
      opts = vim.tbl_deep_extend("force", opts or {}, fragment)
    end
  end

  return opts
end

local function has_config(spec)
  return spec.config ~= nil
end

local function has_opts(spec)
  return not vim.tbl_isempty(spec.opts_fragments)
end

local function should_run_config(spec)
  return has_config(spec) or has_opts(spec)
end

local function run_init_once(spec)
  if spec.init == nil or spec._init_ran then
    return
  end

  spec._init_ran = true

  local ok, err = pcall(spec.init)
  if not ok then
    notify_error(spec.name, "init", err)
  end
end

local function run_config(spec)
  if not should_run_config(spec) then
    return
  end

  local opts = resolve_opts(spec)

  if has_config(spec) then
    spec.config(opts)
    return
  end

  local plugin = require(spec.main)
  plugin.setup(opts)
end

local function init_dependencies(spec)
  for _, key in ipairs(spec.dependencies) do
    local dependency = registry[key]
    if dependency ~= nil and not is_disabled(dependency) and not init_plugin(dependency) then
      return false
    end
  end

  return true
end

init_plugin = function(spec)
  if is_disabled(spec) then
    return false
  end

  if spec._loading then
    notify_error(spec.name, "dependencies", "circular dependency detected")
    return false
  end

  if spec._loaded then
    spec._loading = true
    local ok = init_dependencies(spec)
    spec._loading = false
    return ok
  end

  spec._loading = true

  if not init_dependencies(spec) then
    spec._loading = false
    return false
  end

  if not load_plugin(spec.name) then
    spec._loading = false
    return false
  end

  local ok, err = pcall(run_config, spec)
  if not ok then
    notify_error(spec.name, "config", err)
    spec._loading = false
    return false
  end

  spec._loaded = true
  spec._loading = false
  return true
end

local defer_event_init = {
  BufRead = true,
  BufReadPost = true,
  BufNewFile = true,
}

local function autocmd_opts(spec, event, pattern)
  return {
    group = augroup,
    pattern = pattern,
    desc = "Initialize " .. spec.name,
    once = true,
    callback = function()
      if defer_event_init[event] then
        vim.schedule(function()
          init_plugin(spec)
        end)
        return
      end

      init_plugin(spec)
    end,
  }
end

local function command_from_rhs(rhs)
  return rhs:match("^<[Cc][Mm][Dd]>(.*)<[Cc][Rr]>$") or rhs:match("^:(.*)<[Cc][Rr]>$")
end

local function run_rhs(rhs)
  if rhs == nil then
    return
  end

  if type(rhs) == "function" then
    rhs()
    return
  end

  local cmd = command_from_rhs(rhs)
  if cmd ~= nil then
    vim.cmd(cmd)
    return
  end

  local keys = vim.api.nvim_replace_termcodes(rhs, true, false, true)
  vim.api.nvim_feedkeys(keys, "m", false)
end

local function keymap_opts(key)
  local opts = {}

  for k, v in pairs(key) do
    if type(k) ~= "number" and k ~= "mode" and k ~= "rhs" and k ~= "lhs" then
      opts[k] = v
    end
  end

  if opts.silent == nil then
    opts.silent = true
  end

  return opts
end

local function append_key(spec, key)
  table.insert(spec.keys, key)
end

local function append_keys(spec, keys)
  if keys == nil then
    return
  end

  if type(keys) == "string" then
    append_key(spec, { keys })
    return
  end

  if type(keys) ~= "table" then
    error(("plugin %s has invalid keys"):format(spec.name))
  end

  if keys[1] ~= nil and type(keys[1]) == "string" then
    append_key(spec, keys)
    return
  end

  for _, key in ipairs(keys) do
    append_key(spec, key)
  end
end

local function append_dependency(spec, key)
  if spec.dependency_set[key] then
    return
  end

  spec.dependency_set[key] = true
  table.insert(spec.dependencies, key)
end

local function register_key(spec, key)
  if type(key) == "string" then
    key = { key }
  end

  local lhs = key[1] or key.lhs
  if lhs == nil then
    error(("plugin %s has a key mapping without lhs"):format(spec.name))
  end

  local rhs = key[2] or key.rhs
  local mode = key.mode or "n"

  vim.keymap.set(mode, lhs, function()
    if init_plugin(spec) then
      run_rhs(rhs)
    end
  end, keymap_opts(key))
end

local function register_keys(spec)
  if #spec.keys == spec.registered_key_count then
    return
  end

  for index = spec.registered_key_count + 1, #spec.keys do
    register_key(spec, spec.keys[index])
  end

  spec.registered_key_count = #spec.keys
end

local function clear_events(spec)
  if spec.event_autocmds ~= nil then
    for _, autocmd in ipairs(spec.event_autocmds) do
      pcall(vim.api.nvim_del_autocmd, autocmd)
    end
  end

  spec.event_autocmds = nil
  spec.event_signature = nil
end

local function event_signature(spec)
  return {
    event = spec.event,
    ft = spec.ft,
  }
end

local function names(value, field)
  if type(value) == "string" then
    return { value }
  end

  if type(value) == "table" then
    return value
  end

  error(field .. " must be a string or table")
end

local function event_autocmd(event)
  if event == "VeryLazy" then
    return "User", "VeryLazy"
  end

  return event, nil
end

local function register_event(spec)
  local has_event = spec.event ~= nil and spec.event ~= false and spec.event ~= "manual"
  local has_ft = spec.ft ~= nil and spec.ft ~= false

  if not has_event and not has_ft then
    clear_events(spec)
    return false
  end

  local signature = event_signature(spec)
  if spec.event_autocmds ~= nil and vim.deep_equal(spec.event_signature, signature) then
    return true
  end

  clear_events(spec)
  spec.event_autocmds = {}

  local has_very_lazy = false
  if has_event then
    for _, event in ipairs(names(spec.event, "event")) do
      local autocmd_event, autocmd_pattern = event_autocmd(event)
      table.insert(
        spec.event_autocmds,
        vim.api.nvim_create_autocmd(autocmd_event, autocmd_opts(spec, autocmd_event, autocmd_pattern))
      )

      if event == "VeryLazy" then
        has_very_lazy = true
      end
    end
  end

  if has_ft then
    table.insert(
      spec.event_autocmds,
      vim.api.nvim_create_autocmd("FileType", autocmd_opts(spec, "FileType", names(spec.ft, "ft")))
    )
  end

  spec.event_signature = signature

  if has_very_lazy then
    if very_lazy_dispatched then
      init_plugin(spec)
    else
      schedule_very_lazy()
    end
  end

  return true
end

local function spec_by_pack_name(name)
  for _, key in ipairs(plugin_order) do
    local spec = registry[key]
    if spec.name == name then
      return spec
    end
  end
end

local function register_build_hook()
  if build_hook_registered then
    return
  end

  build_hook_registered = true

  vim.api.nvim_create_autocmd("PackChanged", {
    group = augroup,
    callback = function(ev)
      local data = ev.data or {}
      if data.kind ~= "install" and data.kind ~= "update" then
        return
      end

      if data.spec == nil or data.path == nil then
        return
      end

      local spec = spec_by_pack_name(data.spec.name)
      if spec == nil or is_disabled(spec) then
        return
      end

      run_build(spec, data.path)
    end,
  })
end

local function explicit(spec, key)
  return rawget(spec, key) ~= nil
end

local function is_plugin_spec(spec)
  if type(spec) ~= "table" then
    return false
  end

  if spec.src ~= nil or spec.source ~= nil then
    return true
  end

  local fields = {
    "name",
    "version",
    "enabled",
    "init",
    "build",
    "config",
    "event",
    "ft",
    "opts",
    "keys",
    "dependencies",
  }

  for _, field in ipairs(fields) do
    if spec[field] ~= nil then
      return true
    end
  end

  return false
end

local function dependency_specs(dependencies)
  if dependencies == nil then
    return {}
  end

  if type(dependencies) == "string" then
    return { dependencies }
  end

  if type(dependencies) ~= "table" then
    error("dependencies must be a string or table")
  end

  if is_plugin_spec(dependencies) then
    return { dependencies }
  end

  return dependencies
end

local function existing_plugin(spec)
  local plugin = registry[spec.key]

  if plugin == nil then
    plugin = {
      key = spec.key,
      src = spec.src,
      name = spec.name,
      version = nil,
      main = infer_main(spec.name),
      disabled = disabled_plugins[spec.key] == true,
      top_level = false,
      init = nil,
      _init_ran = false,
      build = nil,
      ft = nil,
      opts_fragments = {},
      keys = {},
      registered_key_count = 0,
      dependencies = {},
      dependency_set = {},
    }
    registry[spec.key] = plugin
    table.insert(plugin_order, spec.key)
  end

  return plugin
end

local function merge_plugin(spec, opts)
  opts = opts or {}

  if spec.enabled == false then
    disabled_plugins[spec.key] = true

    local plugin = registry[spec.key]
    if plugin ~= nil then
      plugin.disabled = true
      clear_events(plugin)
    end

    return plugin
  end

  if disabled_plugins[spec.key] then
    return registry[spec.key]
  end

  local plugin = existing_plugin(spec)

  if opts.top_level then
    plugin.top_level = true
  end

  plugin.src = spec.src

  if explicit(spec.raw, "name") then
    plugin.name = spec.name
    plugin.main = infer_main(plugin.name)
  end

  if explicit(spec.raw, "version") then
    plugin.version = spec.version
  end

  if explicit(spec.raw, "init") then
    if spec.init ~= nil and type(spec.init) ~= "function" then
      error(("plugin %s init must be a function"):format(spec.name))
    end

    plugin.init = spec.init
  end

  if explicit(spec.raw, "build") then
    if
      spec.build ~= nil
      and type(spec.build) ~= "function"
      and type(spec.build) ~= "string"
      and not (type(spec.build) == "table" and vim.islist(spec.build))
    then
      error(("plugin %s build must be a function, string, or list"):format(spec.name))
    end

    plugin.build = spec.build
  end

  if explicit(spec.raw, "config") then
    if spec.config ~= nil and type(spec.config) ~= "function" then
      error(("plugin %s config must be a function"):format(spec.name))
    end

    plugin.config = spec.config
  end

  if explicit(spec.raw, "event") then
    plugin.event = spec.event
  end

  if explicit(spec.raw, "ft") then
    plugin.ft = spec.ft
  end

  if explicit(spec.raw, "opts") then
    table.insert(plugin.opts_fragments, spec.opts)
  end

  append_keys(plugin, spec.keys)

  if explicit(spec.raw, "dependencies") then
    for _, dependency in ipairs(dependency_specs(spec.dependencies)) do
      local dependency_spec = normalize_spec(dependency)
      local dependency_plugin = merge_plugin(dependency_spec, { top_level = false })
      if dependency_plugin ~= nil and not is_disabled(dependency_plugin) then
        append_dependency(plugin, dependency_plugin.key)
      end
    end
  end

  return plugin
end

local function flush()
  flushed = true

  local pack_specs = {}

  for _, key in ipairs(plugin_order) do
    local spec = registry[key]
    if not is_disabled(spec) then
      table.insert(pack_specs, pack_spec(spec))
    end
  end

  if #pack_specs > 0 then
    register_build_hook()
    vim.pack.add(pack_specs, { load = false })
  end

  for _, key in ipairs(plugin_order) do
    local spec = registry[key]

    if is_disabled(spec) then
      clear_events(spec)
    else
      run_init_once(spec)
      register_keys(spec)

      if
        not register_event(spec)
        and spec.event == nil
        and #spec.keys == 0
        and spec.top_level
        and should_run_config(spec)
      then
        init_plugin(spec)
      end
    end
  end
end

function M.add(specs)
  if type(specs) ~= "table" or not vim.islist(specs) then
    error("plugin.add expects a list of plugin specs", 2)
  end

  for _, spec in ipairs(specs) do
    merge_plugin(normalize_spec(spec), { top_level = true })
  end

  if flushed then
    flush()
  end
end

function M.flush()
  flush()
end

function M.setup(specs)
  M.add(specs)
  M.flush()
end

return M
