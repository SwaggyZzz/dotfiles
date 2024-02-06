packadd({
  "nvim-tree/nvim-tree.lua",
  lazy = true,
  cmd = {
    "NvimTreeToggle",
    "NvimTreeOpen",
    "NvimTreeFindFile",
    "NvimTreeFindFileToggle",
    "NvimTreeRefresh",
  },
  config = require("tool.config.nvim-tree"),
})

packadd({
  "nvim-lua/plenary.nvim",
  lazy = true
})

packadd({
  "echasnovski/mini.bufremove",
  version = "*",
  config = function()
    require("mini.bufremove").setup({
      silent = true,
    })
  end,
})

packadd({
  "lewis6991/gitsigns.nvim",
  lazy = true,
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  config = require("tool.config.gitsigns")
})

----------------------------------------------------------------------
--                        Telescope Plugins                         --
----------------------------------------------------------------------
packadd({
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  lazy = true,
  cmd = "Telescope",
  config = require("tool.config.telescope"),
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
    -- { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim" },
    -- { "cljoly/telescope-repo.nvim" },
  }
})
packadd({
  "nvim-telescope/telescope-fzf-native.nvim",
  build = "make",
  lazy = true,
})
