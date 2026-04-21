local M = {}

local health = vim.health

local function has_command(command)
  return vim.fn.executable(command) == 1
end

local function command_path(command)
  return vim.fn.exepath(command)
end

local function report_command(command, opts)
  opts = opts or {}

  if has_command(command) then
    health.ok(("`%s` found: %s"):format(command, command_path(command)))
    return true
  end

  for _, alternative in ipairs(opts.alternatives or {}) do
    if has_command(alternative) then
      health.warn(
        ("`%s` is missing, but `%s` exists: %s"):format(command, alternative, command_path(alternative)),
        opts.advice
      )
      return false
    end
  end

  local report = opts.required and health.error or health.warn
  report(("`%s` is not executable"):format(command), opts.advice)
  return false
end

local function report_any(title, commands, advice)
  local found = {}

  for _, command in ipairs(commands) do
    if has_command(command) then
      found[#found + 1] = command
    end
  end

  if #found > 0 then
    health.ok(("%s: %s"):format(title, table.concat(found, ", ")))
    return true
  end

  health.warn(("%s: none found"):format(title), advice)
  return false
end

local function readable_file(path)
  return vim.uv.fs_stat(path) ~= nil and vim.fn.filereadable(path) == 1
end

local function report_dir(name, path, opts)
  opts = opts or {}

  if path == nil or path == "" then
    health.error(name .. " path is empty")
    return
  end

  if vim.fn.isdirectory(path) == 0 then
    health.warn(("%s does not exist: %s"):format(name, path), opts.missing_advice)
    return
  end

  if opts.writable and vim.fn.filewritable(path) ~= 2 then
    health.error(("%s is not writable: %s"):format(name, path), opts.writable_advice)
    return
  end

  health.ok(("%s: %s"):format(name, path))
end

local function check_neovim()
  health.start("Neovim")

  local version = vim.version()
  local version_text = ("%d.%d.%d"):format(version.major, version.minor, version.patch)

  if version.prerelease then
    version_text = version_text .. "-" .. (type(version.prerelease) == "string" and version.prerelease or "dev")
  end

  health.info("Version: " .. version_text)

  if vim.fn.has("nvim-0.12") == 1 then
    health.ok("Neovim 0.12+ API is available")
  else
    health.error("Neovim 0.12+ is required", {
      "This config uses vim.pack and the modern vim.lsp.config/vim.lsp.enable APIs.",
      "Install a current Neovim release or nightly build.",
    })
  end

  if vim.pack ~= nil and type(vim.pack.add) == "function" then
    health.ok("vim.pack is available")
  else
    health.error("vim.pack is unavailable")
  end

  if vim.version.range ~= nil then
    health.ok("vim.version.range is available")
  else
    health.error("vim.version.range is unavailable")
  end
end

local function check_paths()
  health.start("Paths")

  local config_dir = vim.fn.stdpath("config")
  report_dir("Config directory", config_dir)

  local lockfile = vim.fs.joinpath(config_dir, "nvim-pack-lock.json")
  if readable_file(lockfile) then
    health.ok("Plugin lockfile found: " .. lockfile)
  else
    health.warn("Plugin lockfile is missing: " .. lockfile, {
      "Run Neovim once so vim.pack can create or update the lockfile.",
    })
  end

  report_dir("Data directory", vim.fn.stdpath("data"), {
    writable = true,
    writable_advice = { "vim.pack installs plugins under this directory." },
  })
  report_dir("State directory", vim.fn.stdpath("state"), {
    writable = true,
    writable_advice = { "Neovim writes logs, ShaDa, and LSP state here." },
  })
  report_dir("Cache directory", vim.fn.stdpath("cache"), {
    writable = true,
    writable_advice = { "Some plugins write cache files here." },
  })
end

local function check_core_tools()
  health.start("Core Tools")

  report_command("git", {
    required = true,
    advice = { "vim.pack needs git to install and update plugins." },
  })
  report_command("rg", {
    required = true,
    advice = { "fzf-lua live grep and plugin spec search use ripgrep." },
  })
  report_command("fd", {
    required = true,
    alternatives = { "fdfind" },
    advice = { "Install fd, or create an fd shim that points to fdfind on Debian/Ubuntu." },
  })
  report_command("fzf", {
    required = true,
    advice = { "fzf-lua shells out to the fzf executable." },
  })
  report_command("bat", {
    alternatives = { "batcat" },
    advice = { "Previews are configured to use bat. On Debian/Ubuntu, create a bat shim that points to batcat." },
  })
  report_command("delta", {
    advice = { "delta improves git diff previews when a picker chooses to use it." },
  })
  report_command("gh", {
    advice = { "GitHub issue and pull request pickers use the gh CLI." },
  })
  report_command("zoxide", {
    advice = { "The project picker uses zoxide when it is available." },
  })
end

local function check_language_tools()
  health.start("Language Tools")

  report_command("lua-language-server", {
    advice = { "lua_ls requires the lua-language-server executable." },
  })
  report_command("stylua", {
    advice = { "Lua formatting uses stylua through conform.nvim." },
  })
  report_any("Web formatters", { "deno", "biome", "prettier" }, {
    "JavaScript, TypeScript, JSON, YAML, HTML, and CSS formatting falls back across deno_fmt, biome, and prettier.",
  })
  report_command("clangd", {
    advice = {
      "C and C++ LSP support uses clangd.",
      "On macOS with Homebrew LLVM, add $(brew --prefix llvm)/bin to PATH or create a clangd shim.",
    },
  })
  report_command("cmake", {
    advice = { "cmake-tools.nvim expects cmake for CMake projects." },
  })
  report_any("Native build tools", { "cc", "gcc", "clang", "cl" }, {
    "Tree-sitter parser builds and native plugin builds may need a C compiler.",
  })
  if vim.fn.has("win32") == 0 then
    report_command("make", {
      advice = { "LuaSnip can build jsregexp with make on Unix systems." },
    })
  end
end

local function check_config_modules()
  health.start("Config Modules")

  local modules = {
    "config.plugin",
    "features.statuscolumn",
    "features.indent",
    "features.words",
    "features.pickers",
    "config.lsp.attach",
    "config.lsp.diagnostics",
  }

  for _, module in ipairs(modules) do
    local ok, err = pcall(require, module)
    if ok then
      health.ok("require('" .. module .. "')")
    else
      health.error("require('" .. module .. "') failed", { tostring(err) })
    end
  end
end

function M.check()
  check_neovim()
  check_paths()
  check_core_tools()
  check_language_tools()
  check_config_modules()
end

return M
