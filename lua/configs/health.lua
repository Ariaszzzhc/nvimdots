local M = {}

local core_bin_should_installed = {
  "git",
  "lazygit",
  "fzf",
  "rg",
  "fd",
  "curl",
}

local lsp_should_installed = {
  "basedpyright",
  "gopls",
  "zls",
  "lua-language-server",
  "vtsls",
  "vscode-json-language-server",
  "clangd",
}

local formatter_should_installed = {
  "prettier",
  "stylua",
}

local linter_should_installed = {}

local debugger_should_installed = {
  "dlv",
  "lldb-dap",
  "debugpy",
}

local start = vim.health.start
local ok = vim.health.ok
local warn = vim.health.warn
local error = vim.health.error

local function check_bin(bin_list, err)
  local not_found_output

  if err then
    not_found_output = error
  else
    not_found_output = warn
  end

  for _, bin in ipairs(bin_list) do
    if vim.fn.executable(bin) == 0 then
      not_found_output(("`%s` is not installed"):format(bin))
    else
      ok(("`%s` is installed"):format(bin))
    end
  end
end

function M.check()
  start("executable check")

  check_bin(core_bin_should_installed, true)
  check_bin(lsp_should_installed, false)
  check_bin(formatter_should_installed, false)
  check_bin(linter_should_installed, false)
  check_bin(debugger_should_installed, false)
end

return M
