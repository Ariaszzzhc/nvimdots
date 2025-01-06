local util = require("lspconfig.util")

local options = {
  root_dir = function(startpath)
    local default_pattern = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git")

    local deno_pattern = util.root_pattern("deno.json", "deno.jsonc")

    local deno_matched = deno_pattern(startpath)

    if deno_matched == nil then
      return default_pattern(startpath)
    end
  end,
  single_file_support = false,
}

return options
