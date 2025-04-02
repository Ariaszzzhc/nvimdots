local function virtual_text_document_handler(uri, res, client)
  if not res then
    return nil
  end

  local lines = vim.split(res.result, "\n")
  local bufnr = vim.uri_to_bufnr(uri)

  local current_buf = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  if #current_buf ~= 0 then
    return nil
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_set_option_value("readonly", true, { buf = bufnr })
  vim.api.nvim_set_option_value("modified", false, { buf = bufnr })
  vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
  vim.lsp.buf_attach_client(bufnr, client.id)
end

local function virtual_text_document(uri, client)
  local params = {
    textDocument = {
      uri = uri,
    },
  }
  local result = client:request_sync("deno/virtualTextDocument", params)
  virtual_text_document_handler(uri, result, client)
end

local function denols_handler(err, result, ctx, config)
  if not result or vim.tbl_isempty(result) then
    return nil
  end

  local client = vim.lsp.get_client_by_id(ctx.client_id)
  for _, res in pairs(result) do
    local uri = res.uri or res.targetUri
    if uri:match("^deno:") then
      virtual_text_document(uri, client)
      res["uri"] = uri
      res["targetUri"] = uri
    end
  end

  vim.lsp.handlers[ctx.method](err, result, ctx, config)
end

local function buf_cache(bufnr, client)
  local params = {
    command = "deno.cache",
    arguments = { {}, vim.uri_from_bufnr(bufnr) },
  }
  client:request("workspace/executeCommand", params, function(err, _, ctx)
    if err then
      local uri = ctx.params.arguments[2]
      vim.notify("cache command failed for " .. vim.uri_to_fname(uri), "error")
    end
  end, bufnr)
end

return {
  cmd = { "deno", "lsp" },
  cmd_env = { NO_COLOR = true },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "deno.json", "deno.jsonc" },
  settings = {
    deno = {
      enable = true,
      inlayHints = {
        enable = "on",
        variableTypes = {
          enable = true,
          suppressWhenTypeMatchesName = true,
        },
        functionLikeReturnTypes = {
          enable = true,
        },
        parameterNames = {
          enable = "all",
          suppressWhenArgumentMatchesName = true,
        },
        parameterTypes = {
          enable = true,
        },
        propertyDeclarationTypes = {
          enable = true,
        },
      },
    },
  },
  workspace_required = true,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "DenolsCache", function()
      buf_cache(0, client)
    end, { desc = "Cache a module and all of its dependencies." })
  end,
  handlers = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), {
    ["textDocument/definition"] = denols_handler,
    ["textDocument/typeDefinition"] = denols_handler,
    ["textDocument/references"] = denols_handler,
  }),
}
