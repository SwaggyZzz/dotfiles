packadd({
  "folke/flash.nvim",
  event = "VeryLazy",
  vscode = true,
  ---@type Flash.Config
  opts = {},
  -- stylua: ignore
  keys = {
    { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
  },
})

packadd({
  "nvimdev/hlsearch.nvim",
  lazy = true,
  event = "BufRead",
  opts = {},
})

packadd({
  "lewis6991/gitsigns.nvim",
  lazy = true,
  event = { "CursorHold", "CursorHoldI" },
  config = require("editor.config.gitsigns")
})

packadd({
  "echasnovski/mini.pairs",
  event = "VeryLazy",
  opts = {
    mappings = {
      ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\`].", register = { cr = false } },
    },
  },
})

packadd({
  "folke/ts-comments.nvim",
  event = "VeryLazy",
  opts = {},
})
----------------------------------------------------------------------
--                  :treesitter related plugins                    --
----------------------------------------------------------------------
packadd({
  "nvim-treesitter/nvim-treesitter",
  version = false, -- last release is way too old and doesn't work on Windows
  lazy = true,
  event = "BufReadPre",
  build = ":TSUpdate",
  config = require("editor.config.treesitter"),
  dependencies = {
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    {
      "NvChad/nvim-colorizer.lua",
    },
  },
})

packadd({
  "windwp/nvim-ts-autotag",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    filetypes = {
      "html",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "xml",
    },
  },
})
