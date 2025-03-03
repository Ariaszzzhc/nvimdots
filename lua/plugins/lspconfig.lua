local icons = require("configs.icons")

local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "smjonas/inc-rename.nvim",
      lazy = true,
      cmd = "IncRename",
      opts = {},
    },
  },
  cond = not vim.g.vscode,
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = function(diagnostic)
          for d, icon in pairs(icons.diagnostics) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
              return icon
            end
          end
        end,
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
          [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
          [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
          [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
        },
      },
    },
    inlay_hints = {
      enabled = false,
      exclude = { "vue" },
    },
    codelens = {
      enabled = true,
    },
    capabilities = {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
      },
    },
    format = {
      formatting_options = nil,
      timeout_ms = nil,
    },
  },
}

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

  keymap("n", "<leader>cl", "<cmd>LspInfo<cr>", {
    buffer = bufnr,
    desc = "Lsp Info",
    noremap = true,
    silent = true,
  })

  if client.supports_method("textDocument/definition") then
    keymap("n", "gd", vim.lsp.buf.definition, {
      buffer = bufnr,
      desc = "Goto Definition",
      noremap = true,
      silent = true,
    })
  end

  keymap("n", "gr", vim.lsp.buf.references, {
    buffer = bufnr,
    desc = "References",
    nowait = true,
    noremap = true,
    silent = true,
  })

  keymap("n", "gI", vim.lsp.buf.implementation, {
    buffer = bufnr,
    desc = "Goto Implementation",
    noremap = true,
    silent = true,
  })

  keymap("n", "gy", vim.lsp.buf.type_definition, {
    buffer = bufnr,
    desc = "Goto T[y]pe Definition",
    noremap = true,
    silent = true,
  })

  keymap("n", "gD", vim.lsp.buf.declaration, {
    buffer = bufnr,
    desc = "Goto Declaration",
    noremap = true,
    silent = true,
  })

  keymap("n", "K", function()
    return vim.lsp.buf.hover()
  end, {
    buffer = bufnr,
    desc = "Hover",
    noremap = true,
    silent = true,
  })

  if client.supports_method("textDocument/signatureHelp") then
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

  if client.supports_method("textDocument/codeAction") then
    keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {
      buffer = bufnr,
      desc = "Code Action",
      noremap = true,
      silent = true,
    })
  end

  if client.supports_method("textDocument/codeLens") then
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

  if client.supports_method("workspace/didRenameFiles") or client.supports_method("workspace/willRenameFiles") then
    keymap("n", "<leader>cR", function()
      Snacks.rename.rename_file()
    end, {
      buffer = bufnr,
      desc = "Rename File",
      noremap = true,
      silent = true,
    })
  end

  if client.supports_method("textDocument/inlayHint") then
    Snacks.toggle.inlay_hints():map("<leader>uh")
  end

  if client.supports_method("textDocument/rename") then
    keymap("n", "<leader>cr", function()
      local inc_rename = require("inc_rename")
      return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
    end, {
      buffer = bufnr,
      desc = "Rename",
      noremap = true,
      silent = true,
      expr = true,
    })
  end

  if client.supports_method("textDocument/codeAction") then
    keymap("n", "<leader>cA", actions.source, {
      buffer = bufnr,
      desc = "Source Action",
      noremap = true,
      silent = true,
    })
  end

  if client.supports_method("textDocument/documentHighlight") and Snacks.words.is_enabled() then
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

local _supports_method = {}

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

--- from lazy
--- @param client vim.lsp.Client
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
      if client.supports_method and client.supports_method(method, { bufnr = buffer }) then
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

local lsp_on_attach = require("utils").lsp_on_attach

function M.config(_, opts)
  lsp_on_attach(function(client, bufnr)
    lsp_keymaps(client, bufnr)
  end)

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

  on_dynamic_capability(function(client, bufnr)
    lsp_keymaps(client, bufnr)
  end)

  on_supports_method("textDocument/inlayHint", function(client, bufnr)
    if
      vim.api.nvim_buf_is_valid(bufnr)
      and vim.bo[bufnr].buftype == ""
      and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[bufnr].filetype)
    then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end)

  on_supports_method("textDocument/codeLens", function(client, bufnr)
    vim.lsp.codelens.refresh()
    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
      buffer = bufnr,
      callback = vim.lsp.codelens.refresh,
    })
  end)

  vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

  local servers = opts.servers or {}

  local capabilities = require("utils").lsp_capabilities

  for server, base_server_opts in pairs(servers) do
    local server_opts

    if type(base_server_opts) == "function" then
      server_opts = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities),
      }, base_server_opts())
    else
      server_opts = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities),
      }, base_server_opts)
    end

    require("lspconfig")[server].setup(server_opts)
  end
end

M.toggle_inlay_hints = function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
end

return M
