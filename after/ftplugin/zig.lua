vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), "ZigRun", function()
  Snacks.terminal("zig build run", {
    interactive = false,
  })
end, { desc = "Build and run current zig project" })

vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), "ZigBuild", function()
  Snacks.terminal("zig build")
end, { desc = "Build current zig project" })

vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), "ZigTest", function()
  Snacks.terminal("zig test", {
    interactive = false,
  })
end, { desc = "Test current zig project" })

vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), "ZigRunCurrent", function()
  local file = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())

  Snacks.terminal("zig run " .. file, {
    interactive = false,
  })
end, { desc = "Build and run current zig file" })
