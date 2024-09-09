return {
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    config = require("configs.tools.telescope"),
  },
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   lazy = false,
  --   version = "*",
  --   config = require("configs.tools.nvimtree"),
  --   -- cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
  --   dependencies = {
  --     {
  --       "s1n7ax/nvim-window-picker",
  --       name = "window-picker",
  --       event = "VeryLazy",
  --       version = "2.*",
  --       config = function()
  --         require("window-picker").setup({
  --           hint = "floating-big-letter",
  --           -- whether to show 'Pick window:' prompt
  --           show_prompt = false,
  --           filter_rules = {
  --             -- filter using buffer options
  --             bo = {
  --               -- if the file type is one of following, the window will be ignored
  --               filetype = { "NvimTree", "neo-tree", "notify", "noice" },
  --
  --               -- if the file type is one of following, the window will be ignored
  --               buftype = { "terminal" },
  --             },
  --           },
  --         })
  --       end,
  --     },
  --   },
  -- },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    init = function()
      -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
      -- because `cwd` is not set up properly.
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          else
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == "directory" then
              require("neo-tree")
            end
          end
        end,
      })
    end,
    config = require("configs.tools.neotree"),
  },
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "numToStr/Navigator.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = {
      preset = "modern",
      win = { border = "rounded" },
    },
  },
  {
    "ojroques/nvim-bufdel",
    lazy = true,
    cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
    -- config = function (_, opts)
    --   vim.api.nvim_create_autocmd("User", {
    --     pattern = "PersistenceLoadPost",
    --     callback = function()
    --         vim.notify("=======111")
    --     end,
    --   })
    --   require("persistence").setup(opts)
    -- end
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
    cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
    opts = {
      focus = true,
    },
    keys = {
      { "<leader>xx", "<CMD>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
      { "<leader>xd", "<CMD>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xl", "<CMD>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" },
      { "<leader>xq", "<CMD>Trouble quickfix toggle<CR>", desc = "Quickfix List (Trouble)" },
      { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Todos (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous Trouble/Quickfix Item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Trouble/Quickfix Item",
      },
    },
  },
}
