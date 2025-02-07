if vim.fn.findfile("xmake.lua") ~= "" then
  vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), "XmakeRun", function()
    Snacks.terminal("xmake build && xmake run", {
      interactive = false,
    })
  end, { desc = "Build and run current xmake project" })

  vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), "XmakeBuild", function()
    Snacks.terminal("xmake build")
  end, { desc = "Build current xmake project" })
end
