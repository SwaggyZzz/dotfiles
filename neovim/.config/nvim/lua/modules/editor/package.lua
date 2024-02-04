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
  "rainbowhxch/accelerated-jk.nvim",
  lazy = true,
  event = "VeryLazy",
  config = function()
    require("editor.config.accelerated-jk")
  end
})
-- packadd({
--   "karb94/neoscroll.nvim",
--   lazy = true,
--   event = { "CursorHold", "CursorHoldI" },
--   config = require("editor.config.neoscroll"),
-- })
packadd({
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("editor.config.autopairs")
  end,
})
packadd({
  "kylechui/nvim-surround",
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  config = true,
})
packadd({
  "numToStr/Comment.nvim",
  lazy = true,
  event = { "CursorHold", "CursorHoldI" },
  config = require("editor.config.comment"),
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
  "rareitems/printer.nvim",
  event = "BufEnter",
  ft = {
    "lua",
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
  },
  config = function()
    require("editor.config.printer")
  end,
})
packadd({
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  config = function()
    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
  end,
})
packadd({
  "smoka7/multicursors.nvim",
  event = "VeryLazy",
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'smoka7/hydra.nvim',
  },
  opts = {
    hint_config = false
  },
  keys = {
    {
      '<LEADER>d',
      '<CMD>MCstart<CR>',
      desc = 'multicursor',
    },
    {
      '<LEADER>d',
      '<CMD>MCvisual<CR>',
      mode = "v",
      desc = 'multicursor',
    },
    {
      '<leader><down>',
      '<CMD>MCunderCursor<CR>',
      desc = 'multicursor down',
    },
  },
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
  build = function()
    if #vim.api.nvim_list_uis() ~= 0 then
      vim.api.nvim_command("TSUpdate")
    end
  end,
  event = "BufReadPre",
  config = require("editor.config.treesitter"),
  dependencies = {
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    { "JoosepAlviste/nvim-ts-context-commentstring" },
    { "andymass/vim-matchup" },
    {
      "hiphish/rainbow-delimiters.nvim",
      config = require("editor.config.rainbow"),
    },
    -- {
    -- 	"nvim-treesitter/nvim-treesitter-context",
    -- 	config = require("editor.ts-context"),
    -- },
    {
      "windwp/nvim-ts-autotag",
      config = require("editor.config.autotag"),
    },
    {
      "NvChad/nvim-colorizer.lua",
      config = require("editor.config.colorizer"),
    },
  },
})
