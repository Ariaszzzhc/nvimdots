return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  settings = {
    Lua = {
      format = {
        enable = true,
      },
      hint = {
        enable = true,
        arrayIndex = "Disable", -- "Enable" | "Auto" | "Disable"
        await = true,
        paramName = "Disable", -- "All" | "Literal" | "Disable"
        paramType = true,
        semicolon = "Disable", -- "All" | "SameLine" | "Disable"
        setType = false,
      },
      codeLens = {
        enable = true,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
