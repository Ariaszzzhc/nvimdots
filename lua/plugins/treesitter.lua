local plugin = require("config.plugin")

plugin.add({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function(opts)
      local languages = {}
      local seen = {}

      for _, language in ipairs(opts or {}) do
        if not seen[language] then
          seen[language] = true
          table.insert(languages, language)
        end
      end

      if #languages > 0 then
        require("nvim-treesitter").install(languages)
      end
    end,
  },
})
