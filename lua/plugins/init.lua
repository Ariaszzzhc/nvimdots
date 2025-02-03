LAZY_PLUGIN_SPEC = {}

function spec(item)
  table.insert(LAZY_PLUGIN_SPEC, { import = "plugins." .. item })
end

spec("mini")
spec("snacks")
spec("noice")
spec("lualine")
spec("bufferline")
spec("colorscheme")
spec("blink")
spec("treesitter")
spec("lspconfig")
spec("whichkey")
spec("fzf")
spec("trouble")
spec("conform")
spec("copilot")
spec("commentstring")
spec("dap")
spec("octo")

local lang = require("plugins.lang")

vim.notify(vim.inspect(lang))

vim.tbl_deep_extend("force", LAZY_PLUGIN_SPEC, lang)

vim.notify(vim.inspect(LAZY_PLUGIN_SPEC))

require("plugins.lazy")
