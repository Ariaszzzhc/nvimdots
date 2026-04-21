# My Nvim Config
Personal nvim config, mostly inspired from lazyvim.

## Structure

- `init.lua`: minimal entry point.
- `lua/config`: core options, keymaps, autocmds, icons, plugin API, and common LSP behavior.
- `lua/features`: local features that are integrated directly into this config.
- `lua/plugins`: plugin declarations grouped by domain.
- `lua/plugins/langs`: language-focused plugin declarations. Each language can extend shared plugins like `nvim-treesitter`, `nvim-lspconfig`, and `conform.nvim` through repeated `plugin.add` calls.

## Screenshots
![image](https://github.com/user-attachments/assets/a68058fa-f32e-4f9f-918c-83143881ce1c)
