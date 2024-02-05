packadd({
  "max397574/better-escape.nvim",
  lazy = true,
  event = { "CursorHold", "CursorHoldI" },
  config = require("editor.config.better-escape"),
})
packadd({
  "nvimdev/hlsearch.nvim",
  lazy = true,
  event = "BufRead",
  config = function()
    require('hlsearch').setup()
  end
})
packadd({
  "echasnovski/mini.pairs",
  event = "VeryLazy",
  opts = {},
})
packadd({
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  config = true,
  keys = {
    -- { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
    -- { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    -- { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    -- { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
  },
})
packadd({
  "echasnovski/mini.comment",
  event = "VeryLazy",
  opts = {
    options = {
      ignore_blank_line = true,
      custom_commentstring = function()
        return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
      end,
    },
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Toggle comment (like `gcip` - comment inner paragraph) for both
      -- Normal and Visual modes
      comment = 'gc',

      -- Toggle comment on current line
      comment_line = '<A-/>',

      -- Toggle comment on visual selection
      comment_visual = '<A-/>',

      -- Define 'comment' textobject (like `dgc` - delete whole comment block)
      textobject = 'gc',
    },
  },
})
packadd({
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  opts = { use_diagnostic_signs = true },
})
packadd({
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {},
  keys = {
    {
      "<leader>w",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "<leader>W",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Flash Treesitter Search",
    },
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
})
packadd({
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
})
packadd({
  "sindrets/diffview.nvim",
  lazy = true,
  cmd = { "DiffviewOpen", "DiffviewClose" },
})

----------------------------------------------------------------------
--                  :treesitter related plugins                    --
----------------------------------------------------------------------
packadd({
  "nvim-treesitter/nvim-treesitter",
  version = false,
  build = ":TSUpdate",
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  event = "BufReadPre",
  config = require("editor.config.treesitter"),
  dependencies = {
    { "andymass/vim-matchup" },
    {
      "hiphish/rainbow-delimiters.nvim",
      config = require("editor.config.rainbow"),
    },
    {
      "NvChad/nvim-colorizer.lua",
      config = require("editor.config.colorizer"),
    },
  },
})
packadd({
  "JoosepAlviste/nvim-ts-context-commentstring",
  lazy = true,
  opts = {
    enable_autocmd = false,
  },
})
packadd({
  "windwp/nvim-ts-autotag",
  config = require("editor.config.autotag"),
})

