return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "PyrightOrganizeImports", function()
      client:request("workspace/executeCommand", {
        command = "basedpyright.organizeimports",
        arguments = { vim.uri_from_bufnr(0) },
      }, nil, 0)
    end, { desc = "Organize Imports" })

    vim.api.nvim_buf_create_user_command(bufnr, "PyrightSetPythonPath", function(opts)
      local path = opts.args
      if client.settings then
        client.settings.python = vim.tbl_deep_extend("force", client.settings.python or {}, { pythonPath = path })
      else
        client.config.settings =
          vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
      end
      client:notify("workspace/didChangeConfiguration", { settings = nil })
    end, { desc = "Reconfigure basedpyright with the provided python path", nargs = 1, complete = "file" })
  end,
}
