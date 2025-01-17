LAZY_PLUGIN_SPEC = {}

function spec(item)
  table.insert(LAZY_PLUGIN_SPEC, { import = "plugins." .. item })
end

spec("mini")
spec("snacks")
spec("lualine")
spec("bufferline")
spec("colorscheme")
spec("blink")
spec("treesitter")
spec("lspconfig")
spec("whichkey")
spec("fzf")
spec("gitsigns")
spec("trouble")
spec("none-ls")
spec("copilot")
spec("zen")
spec("commentstring")
spec("lazydev")
spec("yazi")

require("plugins.lazy")
