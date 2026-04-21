# Neovim Config

A personal Neovim configuration built around Neovim's native package manager, a small plugin declaration API, and language-focused plugin modules.

The goal is to keep the config explicit and easy to inspect: core editor behavior lives under `lua/config`, local editor features live under `lua/features`, and plugin declarations live under `lua/plugins`.

## Highlights

- Native package management through `vim.pack`.
- A small `plugin.add` API for declaring plugin source, lazy loading, dependencies, build steps, init hooks, options, and config functions.
- Repeated plugin declarations, so language modules can extend shared plugins such as `nvim-treesitter`, `nvim-lspconfig`, and `conform.nvim`.
- `fzf-lua` based picker workflow.
- Built-in local features for status column, indentation guides, word/reference navigation, picker helpers, and file rename support.
- LSP, formatting, Treesitter, markdown rendering, git signs, completion, snippets, and UI plugins configured in plain Lua.
- Cross-platform install scripts for macOS, Linux, and Windows.
- Local healthcheck available through `:checkhealth config`.

## Requirements

This config expects a recent Neovim build with the modern APIs used by the config.

- Neovim 0.12+
- `git`
- `ripgrep` (`rg`)
- `fd`
- `fzf`
- `bat`

Optional tools improve specific workflows:

- `delta` for git diff previews
- `gh` for GitHub issue and pull request pickers
- `zoxide` for project jumping
- `lua-language-server` and `stylua` for Lua
- `deno`, `biome`, or `prettier` for web formatting
- `clangd` and `cmake` for C/C++
- a C compiler and `make` for native builds and Treesitter parsers

Run `:checkhealth config` after installation to see what is available on the current machine.

## Install

From the repository root:

```sh
./install.sh
```

Windows:

```powershell
.\install.ps1
```

The install scripts:

- install the editor toolchain for the current platform
- link this repository to the standard Neovim config directory when possible
- start Neovim once so `vim.pack` can install plugins
- run the local healthcheck

Supported platforms:

- macOS through Homebrew
- Debian and Ubuntu through `apt`
- Fedora through `dnf`
- Arch Linux through `pacman`
- Windows through `winget`

Script options:

```sh
./install.sh --minimal
./install.sh --no-sync
./install.sh --dry-run
```

```powershell
.\install.ps1 -Minimal
.\install.ps1 -NoSync
.\install.ps1 -DryRun
```

## Healthcheck

The config provides a dedicated Neovim healthcheck:

```vim
:checkhealth config
```

It checks the Neovim version, writable runtime paths, core command-line tools, optional language tools, and important local Lua modules.

## Structure

```text
.
|-- init.lua
|-- install.ps1
|-- install.sh
|-- lua
|   |-- config
|   |   |-- autocmds.lua
|   |   |-- health.lua
|   |   |-- icons.lua
|   |   |-- init.lua
|   |   |-- keymaps.lua
|   |   |-- lsp
|   |   |-- options.lua
|   |   `-- plugin.lua
|   |-- features
|   `-- plugins
|       `-- langs
`-- nvim-pack-lock.json
```

- `init.lua`: minimal entry point.
- `lua/config`: core options, keymaps, autocmds, icons, plugin API, healthcheck, and common LSP behavior.
- `lua/features`: local features that are integrated directly into this config.
- `lua/plugins`: plugin declarations grouped by domain.
- `lua/plugins/langs`: language-focused declarations that extend shared plugins.
- `nvim-pack-lock.json`: lockfile managed by Neovim's package manager.

## Plugin API

Plugins are declared with `require("config.plugin").add`.

```lua
local plugin = require("config.plugin")

plugin.add({
  "author/example.nvim",
  event = "VeryLazy",
  dependencies = {
    "author/dependency.nvim",
  },
  opts = {
    option = true,
  },
})
```

Supported fields include:

- source: `"owner/repo"`, `src`, or `source`
- `name`
- `enabled`
- `init`
- `build`
- `event`
- `ft`
- `dependencies`
- `opts`
- `keys`
- `config`

Default config behavior:

- if neither `opts` nor `config` is provided, the plugin is only added to `vim.pack`
- if `opts` exists and `config` does not, the default config is `require(name).setup(opts)`
- if `config` exists, it receives `opts` as its first argument

Repeated declarations for the same plugin are merged:

- `config`, `event`, `ft`, `name`, `version`, `init`, and `build` use the last declaration
- `opts` are merged
- `keys` are appended in declaration order
- `dependencies` are merged
- any declaration with `enabled = false` disables that plugin

## Language Modules

Language-specific setup lives in `lua/plugins/langs`.

Each language module can extend shared plugins without editing the shared plugin file. For example, a language can add Treesitter parsers, LSP server settings, formatters, and language-only plugins from the same module.

```lua
plugin.add({
  "nvim-treesitter/nvim-treesitter",
  opts = function(opts)
    vim.list_extend(opts, { "lua", "vimdoc" })
    return opts
  end,
}, {
  "neovim/nvim-lspconfig",
  opts = {
    lua_ls = {},
  },
})
```

## Screenshots

![screenshot](https://github.com/user-attachments/assets/a68058fa-f32e-4f9f-918c-83143881ce1c)
