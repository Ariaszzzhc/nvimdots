return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
    "--function-arg-placeholders",
    "--fallback-style=google",
    "--experimental-modules-support",
  },
  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
    "cuda",
    "proto",
  },
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { "utf-8", "utf-16" },
  },
  root_markers = {
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "ClangdSwitchSourceHeader", function()
      local method_name = "textDocument/switchSourceHeader"
      local params = vim.lsp.util.make_text_document_params(0)
      client:request(method_name, params, function(err, result)
        if err then
          error(tostring(err))
        end
        if not result then
          vim.notify("corresponding file cannot be determined")
          return
        end
        vim.cmd.edit(vim.uri_to_fname(result))
      end, 0)
    end, { desc = "Switch between source/header" })

    vim.api.nvim_buf_create_user_command(bufnr, "ClangdShowSymbolInfo", function()
      local win = vim.api.nvim_get_current_win()
      local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
      client:request("textDocument/symbolInfo", params, function(err, res)
        if err or #res == 0 then
          -- Clangd always returns an error, there is not reason to parse it
          return
        end
        local container = string.format("container: %s", res[1].containerName) ---@type string
        local name = string.format("name: %s", res[1].name) ---@type string
        vim.lsp.util.open_floating_preview({ name, container }, "", {
          height = 2,
          width = math.max(string.len(name), string.len(container)),
          focusable = false,
          focus = false,
          border = "single",
          title = "Symbol Info",
        })
      end, 0)
    end, { desc = "Show symbol info" })
  end,
}
