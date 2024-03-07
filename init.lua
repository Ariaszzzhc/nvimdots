LAZY_PLUGIN_SPEC = {}

function spec(item)
  table.insert(LAZY_PLUGIN_SPEC, { import = item })
end

require("oathkeeper.mappings")
require("oathkeeper.options")
spec("oathkeeper.colorscheme")
spec("oathkeeper.whichkey")
spec("oathkeeper.telescope")
spec("oathkeeper.treesitter")
spec("oathkeeper.lspconfig")
spec("oathkeeper.cmp")
spec("oathkeeper.schemastore")
spec("oathkeeper.autopairs")
spec("oathkeeper.comment")
spec("oathkeeper.lualine")
spec("oathkeeper.neogit")
require("oathkeeper.lazy")

