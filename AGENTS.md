# AGENTS.md - Neovim Configuration Guidelines

This is a Neovim configuration repository. Unlike traditional codebases, this primarily consists of Lua configuration files and plugin specifications.

## Commands

### Testing Changes
- **Reload config**: Restart Neovim or run `:source %` on `init.lua` to reload the current buffer
- **Check for errors**: Open Neovim and check for any error messages on startup
- **Lazy plugin manager**: Run `:Lazy` to view plugin status and check for issues
- **Health check**: Run `:checkhealth` to diagnose configuration issues

### Linting & Formatting
- **Lua formatting**: Uses `stylua` (configured via `conform.nvim`)
- **Auto-format on save**: Enabled for Lua files via conform.nvim
- **Manual format**: `<leader>cf` to format the current buffer

### Tree-sitter
- **Update parsers**: Run `:TSUpdate` to update Tree-sitter parsers
- **Install parsers**: Run `:TSInstall <language>` to install specific parsers

## Code Style Guidelines

### Imports
- Use `local <name> = require("<module>")` pattern for module imports
- Group related requires together
- Use relative paths: `require("configs.options")` not `require("lua/configs/options")`
- Example: `local icons = require("configs.icons")`

### Indentation & Spacing
- **Default**: 2-space indent for most files (from .editorconfig)
- **Vim options**: shiftwidth=4, tabstop=4, expandtab=true
- **One blank line** between function definitions and logical sections
- **No trailing whitespace** (trim_trailing_whitespace=true)

### Naming Conventions
- **Variables/functions**: snake_case (e.g., `lsp_on_attach`, `exe_picker`)
- **Tables**: camelCase for keys (e.g., `{ desc = "Buffer", mode = "n" }`)
- **Constants**: UPPER_SNAKE_CASE for truly constant values
- **Plugin specs**: `priority` for load order, `version = false` for dev versions
- **Keymaps**: Use descriptive `desc` field for all mappings

### Functions
- Use `local function name()` syntax for local functions
- Return tables at the end of modules (common pattern: `return { ... }`)
- Use `function(_, opts)` signature for config functions when not using args
- Add type annotations using EmmyLua syntax: `--- @param ...`, `--- @return ...`

### Tables & Configuration
- Plugin specs: `{ "plugin/repo", opts = {}, event = "...", keys = {...} }`
- Keys/mappings: `{ "<leader>ff", function() ... end, desc = "Find Files" }`
- Vim options: Use `vim.opt` (e.g., `vim.opt.number = true`)
- Global vim variables: `vim.g.<name>` (e.g., `vim.g.vscode`)

### Keymaps
- Use the helper function: `map(modes, lhs, rhs, opts)`
- Always include `desc` field for documentation
- Use `expr = true` for expression mappings
- Use `noremap = true` for non-recursive mappings
- Group related keymaps together with comments

### Error Handling
- Use `vim.api.nvim_echo()` for startup errors
- Check `vim.v.shell_error` for command results
- Validate buffer validity: `vim.api.nvim_buf_is_valid(buffer)`
- Use conditional guards: `if not condition then return end`

### Comments
- Use `--` for single-line comments
- Use `--[[ ... ]]` for multi-line comments
- Add comments for complex logic or non-obvious behavior
- Document plugin configuration sections

### Specific Patterns
- **LSP on_attach**: Create reusable `lsp_keymaps()` function
- **Diagnostic goto**: Use helper function pattern for severity filtering
- **Plugin cond**: Use `cond = not vim.g.vscode` for VSCode-specific config
- **Autocmds**: Use `vim.api.nvim_create_autocmd` with descriptive patterns

### File Organization
- `init.lua`: Entry point and lazy.nvim bootstrap
- `lua/configs/`: Core configuration modules (options, mappings, lsp, etc.)
- `lua/plugins.lua`: Plugin specifications
- `lsp/*.lua`: LSP server configurations
- `after/ftplugin/`: File-type specific settings
- `dap/*.lua`: Debug adapter configurations
