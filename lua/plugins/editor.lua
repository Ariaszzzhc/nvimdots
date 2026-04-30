local plugin = require("config.plugin")

plugin.add({
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
  },
  {
    "nvim-mini/mini.bufremove",
    enabled = not vim.g.vscode,
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete()
        end,
        desc = "Delete Buffer",
      },
      { "<leader>bD", "<Cmd>bd<CR>", desc = "Delete Buffer and Window" },
    },
  },
  {
    "nvim-mini/mini.files",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      mappings = {
        go_in = "L",
        go_in_plus = "l",
      },
      options = {
        permanent_delete = false,
        use_as_default_explorer = true,
      },
      windows = {
        preview = true,
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          local files = require("mini.files")
          local path = vim.api.nvim_buf_get_name(0)
          if path == "" then
            path = vim.fn.getcwd()
          end

          if not files.close() then
            files.open(path, false)
          end
        end,
        desc = "Explorer Current File",
      },
      {
        "<leader>E",
        function()
          local files = require("mini.files")

          if not files.close() then
            files.open(vim.fn.getcwd(), true)
          end
        end,
        desc = "Explorer Cwd",
      },
    },
    config = function(opts)
      require("mini.files").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("MiniFilesLspRename", { clear = true }),
        pattern = { "MiniFilesActionRename", "MiniFilesActionMove" },
        callback = function(args)
          local data = args.data
          if data == nil or data.from == nil or data.to == nil then
            return
          end

          require("features.rename").on_rename_file(data.from, data.to)
        end,
      })
    end,
  },
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },
  {
    "nvim-mini/mini.comment",
    event = "VeryLazy",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        name = "ts_context_commentstring",
        opts = {
          enable_autocmd = false,
        },
        config = function(opts)
          require("ts_context_commentstring").setup(opts)
        end,
      },
    },
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "folke/which-key.nvim",
    },
    opts = function()
      local ai = require("mini.ai")

      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" },
          e = {
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          g = function(ai_type)
            local start_line, end_line = 1, vim.fn.line("$")
            if ai_type == "i" then
              local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
              if first_nonblank == 0 or last_nonblank == 0 then
                return { from = { line = start_line, col = 1 } }
              end
              start_line, end_line = first_nonblank, last_nonblank
            end

            local to_col = math.max(vim.fn.getline(end_line):len(), 1)
            return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
          end,
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
        },
      }
    end,
    config = function(opts)
      require("mini.ai").setup(opts)

      vim.schedule(function()
        local objects = {
          { " ", desc = "whitespace" },
          { '"', desc = '" string' },
          { "'", desc = "' string" },
          { "(", desc = "() block" },
          { ")", desc = "() block with ws" },
          { "<", desc = "<> block" },
          { ">", desc = "<> block with ws" },
          { "?", desc = "user prompt" },
          { "U", desc = "use/call without dot" },
          { "[", desc = "[] block" },
          { "]", desc = "[] block with ws" },
          { "_", desc = "underscore" },
          { "`", desc = "` string" },
          { "a", desc = "argument" },
          { "b", desc = ")]} block" },
          { "c", desc = "class" },
          { "d", desc = "digit(s)" },
          { "e", desc = "CamelCase / snake_case" },
          { "f", desc = "function" },
          { "g", desc = "entire file" },
          { "i", desc = "indent" },
          { "o", desc = "block, conditional, loop" },
          { "q", desc = "quote `\"'" },
          { "t", desc = "tag" },
          { "u", desc = "use/call" },
          { "{", desc = "{} block" },
          { "}", desc = "{} with ws" },
        }

        local ret = { mode = { "o", "x" } }
        local mappings = vim.tbl_extend("force", {}, {
          around = "a",
          inside = "i",
          around_next = "an",
          inside_next = "in",
          around_last = "al",
          inside_last = "il",
        }, opts.mappings or {})
        mappings.goto_left = nil
        mappings.goto_right = nil

        for name, prefix in pairs(mappings) do
          name = name:gsub("^around_", ""):gsub("^inside_", "")
          ret[#ret + 1] = { prefix, group = name }
          for _, obj in ipairs(objects) do
            local desc = obj.desc
            if prefix:sub(1, 1) == "i" then
              desc = desc:gsub(" with ws", "")
            end
            ret[#ret + 1] = { prefix .. obj[1], desc = desc }
          end
        end

        require("which-key").add(ret, { notify = false })
      end)
    end,
  },
})
