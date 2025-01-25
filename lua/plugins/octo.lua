local M = {
  "pwntester/octo.nvim",
  cmd = "Octo",
  event = { { event = "BufReadCmd", pattern = "octo://*" } },
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  cond = not vim.g.vscode,
  keys = {
    { "<leader>gi", "<cmd>Octo issue list<CR>", desc = "List Issues (Github)" },
    { "<leader>gI", "<cmd>Octo issue search<CR>", desc = "Search Issues (Github)" },
    { "<leader>gp", "<cmd>Octo pr list<CR>", desc = "List PRs (Github)" },
    { "<leader>gP", "<cmd>Octo pr search<CR>", desc = "Search PRs (Github)" },
    { "<leader>gr", "<cmd>Octo repo list<CR>", desc = "List Repos (Github)" },
    { "<leader>gS", "<cmd>Octo search<CR>", desc = "Search (Github)" },

    { "<localleader>a", "", desc = "+assignee (Github)", ft = "octo" },
    { "<localleader>c", "", desc = "+comment/code (Github)", ft = "octo" },
    { "<localleader>l", "", desc = "+label (Github)", ft = "octo" },
    { "<localleader>i", "", desc = "+issue (Github)", ft = "octo" },
    { "<localleader>r", "", desc = "+react (Github)", ft = "octo" },
    { "<localleader>p", "", desc = "+pr (Github)", ft = "octo" },
    { "<localleader>pr", "", desc = "+rebase (Github)", ft = "octo" },
    { "<localleader>ps", "", desc = "+squash (Github)", ft = "octo" },
    { "<localleader>v", "", desc = "+review (Github)", ft = "octo" },
    { "<localleader>g", "", desc = "+goto_issue (Github)", ft = "octo" },
    { "@", "@<C-x><C-o>", mode = "i", ft = "octo", silent = true },
    { "#", "#<C-x><C-o>", mode = "i", ft = "octo", silent = true },
  },
}

function M.config()
  vim.treesitter.language.register("markdown", "octo")
  require("octo").setup({
    enable_builtin = true,
    default_to_projects_v2 = true,
    default_merge_method = "squash",
    picker = "fzf-lua",
  })

  vim.api.nvim_create_autocmd("ExitPre", {
    group = vim.api.nvim_create_augroup("octo_exit_pre", { clear = true }),
    callback = function(ev)
      local keep = { "octo" }
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.tbl_contains(keep, vim.bo[buf].filetype) then
          vim.bo[buf].buftype = "" -- set buftype to empty to keep the window
        end
      end
    end,
  })
end

return M
