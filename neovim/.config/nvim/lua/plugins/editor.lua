return {
  {
    "nvimdev/hlsearch.nvim",
    lazy = true,
    event = "BufRead",
    opts = {},
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {
      modes = {
        -- options used when flash is activated through
        -- a regular search with `/` or `?`
        search = {
          -- when `true`, flash will be activated during regular search by default.
          -- You can always toggle when searching with `require("flash").toggle()`
          enabled = true,
        },
      },
      label = {
        -- allow uppercase labels
        uppercase = false,
      },
    },
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      -- import nvim-autopairs
      local autopairs = require("nvim-autopairs")

      -- configure autopairs
      autopairs.setup({
        check_ts = true, -- enable treesitter
        ts_config = {
          lua = { "string" }, -- don't add pairs in lua string treesitter nodes
          javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
          java = false, -- don't check treesitter on java
        },
      })

      -- import nvim-autopairs completion functionality
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")

      -- import nvim-cmp plugin (completions plugin)
      local cmp = require("cmp")

      -- make autopairs and completion work together
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "kylechui/nvim-surround",
    event = { "BufReadPre", "BufNewFile" },
    version = "*",
    config = true,
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      -- import comment plugin safely
      local comment = require("Comment")

      local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

      -- enable comment
      comment.setup({
        -- for commenting tsx, jsx, svelte, html files
        pre_hook = ts_context_commentstring.create_pre_hook(),
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        exclude = { "big_file_disabled_ft", "checkhealth" },
      },
    },
  },
  -- {
  --   "kevinhwang91/nvim-ufo",
  --   event = "VeryLazy",
  --   dependencies = "kevinhwang91/promise-async",
  --   config = function()
  --     local map = vim.keymap.set
  --     map("n", "zR", require("ufo").openAllFolds, { desc = "Open All Folds" })
  --     map("n", "zM", require("ufo").closeAllFolds, { desc = "Close All Folds" })
  --     map("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open Folds Except Kinds" })
  --     map("n", "zm", require("ufo").closeFoldsWith, { desc = "Close Folds With Number" }) -- closeAllFolds == closeFoldsWith(0)
  --   end,
  -- },
}
