LAZY_PLUGIN_SPEC = {}

function spec(item)
  table.insert(LAZY_PLUGIN_SPEC, { import = "plugins." .. item })
end

spec("mini")
spec("snacks")
spec("dress")
spec("colorscheme")
spec("blink")
spec("treesitter")
spec("lspconfig")
spec("whichkey")
spec("fzf")
spec("gitsigns")
spec("trouble")

require("plugins.lazy")
