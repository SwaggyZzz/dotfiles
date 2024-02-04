packadd({ "nvim-lua/plenary.nvim", lazy = true })
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
  "echasnovski/mini.bufremove",
  version = "*",
  config = function()
    require("mini.bufremove").setup({
      silent = true,
    })
  end,
})
----------------------------------------------------------------------
--                        Telescope Plugins                         --
----------------------------------------------------------------------
packadd({
  "nvim-telescope/telescope.nvim",
  lazy = true,
  cmd = "Telescope",
  config = require("tool.config.telescope"),
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "cljoly/telescope-repo.nvim" },
  }
})
