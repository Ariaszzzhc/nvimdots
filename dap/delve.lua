return function(callback, config)
  ---@diagnostic disable-next-line: undefined-field
  if config.mode == "remote" and config.request == "attach" then
    callback({
      type = "server",
      ---@diagnostic disable-next-line: undefined-field
      host = config.host or "127.0.0.1",
      ---@diagnostic disable-next-line: undefined-field
      port = config.port or "38697",
    })
  else
    callback({
      type = "server",
      port = "${port}",
      executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
      },
      detached = vim.fn.has("win32") == 0,
    })
  end
end
