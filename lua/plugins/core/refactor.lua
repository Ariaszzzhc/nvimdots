return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = false,
  keys = {
    {
      "<leader>rm",
      function()
        require("refactoring").select_refactor({
          show_success_message = true,
        })
      end,
      mode = { "n", "v" },
      desc = "Refactoring Menu",
    },
  },
  opts = {},
}
