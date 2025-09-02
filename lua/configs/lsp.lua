local icons = require("configs.icons")

local function lsp_on_attach(on_attach, name)
  return vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        return on_attach(client, buffer)
      end
    end,
  })
end

local actions = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})

local function lsp_keymaps(client, bufnr)
  local keymap = vim.keymap.set

  keymap("n", "K", function()
    return vim.lsp.buf.hover()
  end, {
    buffer = bufnr,
    desc = "Hover",
    noremap = true,
    silent = true,
  })

  if client:supports_method("textDocument/signatureHelp") then
    keymap("n", "gK", function()
      return vim.lsp.buf.signature_help()
    end, {
      buffer = bufnr,
      desc = "Signature Help",
      noremap = true,
      silent = true,
    })

    keymap("i", "<c-k>", function()
      return vim.lsp.buf.signature_help()
    end, {
      buffer = bufnr,
      desc = "Signature Help",
      noremap = true,
      silent = true,
    })
  end

  if client:supports_method("textDocument/codeAction") then
    keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {
      buffer = bufnr,
      desc = "Code Action",
      noremap = true,
      silent = true,
    })
  end

  if client:supports_method("textDocument/codeLens") then
    keymap({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, {
      buffer = bufnr,
      desc = "Run Codelens",
      noremap = true,
      silent = true,
    })

    keymap("n", "<leader>cC", vim.lsp.codelens.refresh, {
      buffer = bufnr,
      desc = "Refresh & Display Codelens",
      noremap = true,
      silent = true,
    })
  end

  if client:supports_method("workspace/didRenameFiles") or client:supports_method("workspace/willRenameFiles") then
    keymap("n", "<leader>cR", function()
      Snacks.rename.rename_file()
    end, {
      buffer = bufnr,
      desc = "Rename File",
      noremap = true,
      silent = true,
    })
  end

  if client:supports_method("textDocument/inlayHint") then
    Snacks.toggle.inlay_hints():map("<leader>uh")
  end

  if client:supports_method("textDocument/rename") then
    keymap("n", "<leader>cr", vim.lsp.buf.rename, {
      buffer = bufnr,
      desc = "Rename",
      noremap = true,
      silent = true,
      expr = true,
    })
  end

  if client:supports_method("textDocument/codeAction") then
    keymap("n", "<leader>cA", actions.source, {
      buffer = bufnr,
      desc = "Source Action",
      noremap = true,
      silent = true,
    })
  end

  if client:supports_method("textDocument/documentHighlight") and Snacks.words.is_enabled() then
    keymap("n", "]]", function()
      Snacks.words.jump(vim.v.count1)
    end, {
      buffer = bufnr,
      desc = "Next Reference",
      noremap = true,
      silent = true,
    })

    keymap("n", "[[", function()
      Snacks.words.jump(-vim.v.count1)
    end, {
      buffer = bufnr,
      desc = "Prev Reference",
      noremap = true,
      silent = true,
    })
    keymap("n", "<a-n>", function()
      Snacks.words.jump(vim.v.count1, true)
    end, {
      buffer = bufnr,
      desc = "Next Reference",
      noremap = true,
      silent = true,
    })
    keymap("n", "<a-p>", function()
      Snacks.words.jump(-vim.v.count1, true)
    end, {
      buffer = bufnr,
      desc = "Prev Reference",
      noremap = true,
      silent = true,
    })
  end
end

--- @type table<string, vim.lsp.Client[]>
local _supports_method = {}

--- from lazy
--- @param client vim.lsp.Client
--- @param buffer number
local function check_methods(client, buffer)
  -- don't trigger on invalid buffers
  if not vim.api.nvim_buf_is_valid(buffer) then
    return
  end
  -- don't trigger on non-listed buffers
  if not vim.bo[buffer].buflisted then
    return
  end
  -- don't trigger on nofile buffers
  if vim.bo[buffer].buftype == "nofile" then
    return
  end
  for method, clients in pairs(_supports_method) do
    clients[client] = clients[client] or {}
    if not clients[client][buffer] then
      if client.supports_method and client:supports_method(method, buffer) then
        clients[client][buffer] = true
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspSupportsMethod",
          data = { client_id = client.id, buffer = buffer, method = method },
        })
      end
    end
  end
end

--- @param fn fun(client:vim.lsp.Client, buffer):boolean?
--- @param opts? {group?: integer}
local function on_dynamic_capability(fn, opts)
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspDynamicCapability",
    group = opts and opts.group or nil,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client then
        return fn(client, buffer)
      end
    end,
  })
end

--- from lazy
--- @param method string
--- @param fn fun(client:vim.lsp.Client, buffer)
local function on_supports_method(method, fn)
  _supports_method[method] = _supports_method[method] or setmetatable({}, { __mode = "k" })
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspSupportsMethod",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client and method == args.data.method then
        return fn(client, buffer)
      end
    end,
  })
end

lsp_on_attach(lsp_keymaps)

local register_capability = vim.lsp.handlers["client/registerCapability"]
vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
  ---@diagnostic disable-next-line: no-unknown
  local ret = register_capability(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if client then
    for buffer in pairs(client.attached_buffers) do
      vim.api.nvim_exec_autocmds("User", {
        pattern = "LspDynamicCapability",
        data = { client_id = client.id, buffer = buffer },
      })
    end
  end
  return ret
end

lsp_on_attach(check_methods)
on_dynamic_capability(check_methods)
on_dynamic_capability(lsp_keymaps)

on_supports_method("textDocument/codeLens", function(_, bufnr)
  vim.lsp.codelens.refresh()
  vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
    buffer = bufnr,
    callback = vim.lsp.codelens.refresh,
  })
end)

on_supports_method("textDocument/documentColor", function(_, bufnr)
  vim.lsp.document_color.enable(true, bufnr, { style = " " })
end)

vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_lines = {
    current_line = true,
    format = function(diagnostic)
      for d, icon in pairs(icons.diagnostics) do
        if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
          return icon .. " " .. diagnostic.message
        end
      end

      if diagnostic.code ~= nil then
        return "" .. diagnostic.code .. ": " .. diagnostic.message
      end

      return diagnostic.message
    end,
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
    },
  },
})

vim.lsp.enable({
  "clangd",
  "denols",
  "tailwindcss",
  "vtsls",
  "zls",
  "eslint",
  "gopls",
  "astro",
  "basedpyright",
  "jsonls",
  "lua_ls",
  "wgsl_analyzer",
})
