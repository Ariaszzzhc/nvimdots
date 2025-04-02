return {
  exe_picker = function(exe_cb)
    Snacks.picker.files({
      cwd = vim.fn.getcwd(),
      cmd = "fd",
      args = { "--type", "x" },
      title = "Select executable",
      layout = "select",
      confirm = function(picker, selection)
        if selection then
          exe_cb(selection._path)
        end
        picker:close()
      end,
    })
  end,
}
