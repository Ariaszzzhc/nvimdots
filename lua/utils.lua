local picker = require("fzf-lua")
local blink = require("blink.cmp")

return {
  exe_picker = function(exe_cb)
    picker.files({
      previewer = false,
      prompt = "> ",
      cwd = vim.fn.getcwd(),
      fd_opts = "--type x",
      actions = {
        ["default"] = exe_cb,
      },
      winopts = {
        title = "Select executable",
      },
    })
  end,
  lsp_capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    blink.get_lsp_capabilities()
  ),
}
