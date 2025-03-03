-- local picker = require("fzf-lua")
local blink = require("blink.cmp")

return {
  exe_picker = function(exe_cb)
    Snacks.picker.files({
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
  --- from lazy
  --- @param on_attach fun(client:vim.lsp.Client, buffer)
  --- @param name? string
  lsp_on_attach = function(on_attach, name)
    return vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local buffer = args.buf ---@type number
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and (not name or client.name == name) then
          return on_attach(client, buffer)
        end
      end,
    })
  end,
}
