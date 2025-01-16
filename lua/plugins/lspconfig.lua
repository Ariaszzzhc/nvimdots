local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "williamboman/mason-lspconfig.nvim", config = function() end },
  },
  init = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if not client then return end

        if client.supports_method("textDocument/formatting") then
          if client.name == "ts_ls" then
            return
          end

          if client.name == "vtsls" then
            return
          end

          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({
                async = false,
                bufnr = args.buf,
                id = client.id,
              })
            end,
          })
        end
      end
    })
  end
}

function M.opts()
  local icons = require("configs.icons")

  local options = {
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
      enabled = true,
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
    }
  }

  return options
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
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

--- from lazy
--- @param on_attach fun(client:vim.lsp.Client, buffer)
--- @param name? string
local function on_attach(on_attach, name)
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


function M.config(_, opts)
  on_attach(function(_, bufnr)
    lsp_keymaps(bufnr)
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
  on_attach(check_methods)
  on_dynamic_capability(check_methods)

  on_dynamic_capability(function(client, bufnr)
    lsp_keymaps(bufnr)
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
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = bufnr,
      callback = vim.lsp.codelens.refresh,
    })
  end)

  vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

  local servers = require("configs.lsp")
  local blink = require("blink.cmp")

  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    blink.get_lsp_capabilities(),
    opts.capabilities
  )

  for server, _ in pairs(servers) do
    local server_opts = vim.tbl_deep_extend("force", {
      capabilities = vim.deepcopy(capabilities),
    }, servers[server] or {})

    require("lspconfig")[server].setup(server_opts)
  end
end

M.toggle_inlay_hints = function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
end

-- function M.config()
--   local wk = require("which-key")
--   wk.add({
--     { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>",                             desc = "Code Action" },
--     {
--      "<leader>lf",
--       "<cmd>lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= 'typescript-tools' end})<cr>",
--       desc = "Format",
--     },
--     { "<leader>li", "<cmd>LspInfo<cr>",                                                   desc = "Info" },
--     { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>",                            desc = "Next Diagnostic" },
--     { "<leader>lh", "<cmd>lua require('user.plugin.lspconfig').toggle_inlay_hints()<cr>", desc = "Hints" },
--     { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>",                            desc = "Prev Diagnostic" },
--     { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>",                                desc = "CodeLens Action" },
--     { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>",                           desc = "Quickfix" },
--     { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>",                                  desc = "Rename" },
--   })

--   local lspconfig = require("lspconfig")
--   local icons = require("user.ui.icons")

--   local servers = {
--     "lua_ls",
--    "clangd",
--     "cssls",
--     "html",
--     "pyright",
--     "bashls",
--     "jsonls",
--     "yamlls",
--     "denols",
--     "ts_ls",
--     "zls",
--     "tailwindcss",
--   }

--   local default_diagnostic_config = {
--     signs = {
--       active = true,
--       values = {
--         { name = "DiagnosticSignError", text = icons.diagnostics.Error },
--         { name = "DiagnosticSignWarn",  text = icons.diagnostics.Warning },
--         { name = "DiagnosticSignHint",  text = icons.diagnostics.Hint },
--         { name = "DiagnosticSignInfo",  text = icons.diagnostics.Information },
--       },
--     },
--     virtual_text = true,
--     update_in_insert = false,
--     underline = true,
--     severity_sort = true,
--     inlay_hints = {
--       enabled = true,
--     },
--     codelens = {
--       enabled = true,
--     },
--     float = {
--       focusable = true,
--       style = "minimal",
--       border = "rounded",
--       source = "always",
--       header = "",
--       prefix = "",
--     },
--   }

--   vim.diagnostic.config(default_diagnostic_config)

--   for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config() or {}, "signs", "values") or {}) do
--     vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
--   end

--   vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
--   vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
--   require("lspconfig.ui.windows").default_options.border = "rounded"

--   for _, server in pairs(servers) do
--     local require_ok, options = pcall(require, "user.lsp." .. server)

--     local opts = {
--       on_attach = M.on_attach,
--       capabilities = require("blink.cmp").get_lsp_capabilities(M.common_capabilities()),
--     }

--     if require_ok then
--       opts.on_attach = M.on_attach
--       opts = vim.tbl_deep_extend("force", options, opts)
--     end

--     if server == "lua_ls" then
--       require("neodev").setup()
--     end

--     lspconfig[server].setup(opts)
--   end
-- end

return M
