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
spec("autopairs")
spec("comment")
spec("lualine")
spec("neogit")
spec("alpha")
spec("nvimtree")
spec("devicons")
spec("navic")
spec("breadcrumbs")
spec("none-ls")
spec("gitsigns")
spec("illuminate")
spec("copilot")
spec("indentline")
spec("trouble")
spec("dress")
spec("bufferline")
spec("notify")
spec("linting")

require("user.plugin.lazy")


