local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "echasnovski/mini.nvim"
    },
    {
      "nvim-lua/plenary.nvim",
    },
    {
      "nvim-telescope/telescope-file-browser.nvim"
    }
  },
}

function M.config()
  local wk = require("which-key")
  wk.add {
    { "<leader>fb", "<cmd>Telescope buffers previewer=false<cr>", desc = "Find Buffer" },
    { "<leader>fB", "<cmd>Telescope git_branches<cr>",            desc = "Checkout branch" },
    { "<leader>fc", "<cmd>Telescope colorscheme<cr>",             desc = "Colorscheme" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>",              desc = "Find files" },
    { "<leader>ft", "<cmd>Telescope live_grep<cr>",               desc = "Find Text" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>",               desc = "Help" },
    { "<leader>fl", "<cmd>Telescope resume<cr>",                  desc = "Last Search" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                desc = "Recent File" },
    { "<leader>e",  "<cmd>Telescope file_browser<cr>",            desc = "File Explorer" }
  }

  local icons = require("user.ui.icons")
  local actions = require("telescope.actions")

  local telescope = require("telescope")

  local mini_sorter = require("mini.fuzzy").get_telescope_sorter


  telescope.setup {
    defaults = {
      prompt_prefix = icons.ui.Telescope .. " ",
      selection_caret = icons.ui.Forward .. " ",
      entry_prefix = "   ",
      initial_mode = "insert",
      selection_strategy = "reset",
      path_display = { "smart" },
      color_devicons = true,
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!.git/",
      },
      generic_sorter = mini_sorter,
      file_sorter = mini_sorter,

      mappings = {
        i = {
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,

          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        },
        n = {
          ["<esc>"] = actions.close,
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["q"] = actions.close,
        },
      },
    },
    pickers = {
      buffers = {
        previewer = false,
        initial_mode = "normal",
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },
          n = {
            ["dd"] = actions.delete_buffer,
          },
        },
      },

      planets = {
        show_pluto = true,
        show_moon = true,
      },

      colorscheme = {
        enable_preview = true,
      },

      lsp_references = {
        initial_mode = "normal",
      },

      lsp_definitions = {
        initial_mode = "normal",
      },

      lsp_declarations = {
        initial_mode = "normal",
      },

      lsp_implementations = {
        initial_mode = "normal",
      },
    },
    extensions = {
    },
  }

  telescope.load_extension("file_browser")
end

return M
