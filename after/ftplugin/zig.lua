vim.api.nvim_create_user_command("ZigRun", function()
  Snacks.terminal("zig build run", {
    interactive = false,
  })
end, { desc = "Build and run current zig project" })

vim.api.nvim_create_user_command("ZigBuild", function()
  Snacks.terminal("zig build")
end, { desc = "Build current zig project" })

vim.api.nvim_create_user_command("ZigTest", function()
  Snacks.terminal("zig test", {
    interactive = false,
  })
end, { desc = "Test current zig project" })

vim.api.nvim_create_user_command("ZigRunCurrent", function()
  local file = vim.api.nvim_buf_get_name(0)

  Snacks.terminal("zig run " .. file, {
    interactive = false,
  })
end, { desc = "Build and run current zig file" })
