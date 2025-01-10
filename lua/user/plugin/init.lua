LAZY_PLUGIN_SPEC = {}

function spec(item)
  table.insert(LAZY_PLUGIN_SPEC, { import = "user.plugin." .. item })
end

spec("colorscheme")
spec("whichkey")
spec("telescope")
spec("treesitter")
spec("lspconfig")
spec("cmp")
spec("schemastore")
spec("comment")
spec("lualine")
spec("neogit")
spec("none-ls")
spec("gitsigns")
spec("illuminate")
spec("copilot")
spec("trouble")
spec("dress")
spec("bufferline")
spec("term")
spec("zen")

require("user.plugin.mini")
require("user.plugin.lazy")
