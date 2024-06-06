packadd({
  'numToStr/Navigator.nvim',
  event = "VeryLazy",
  opts = {}
})

packadd({
  "nvim-tree/nvim-tree.lua",
  lazy = true,
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  config = require "tool.config.nvim-tree",
})

packadd({ "nvim-lua/plenary.nvim", lazy = true })

packadd({
  "ojroques/nvim-bufdel",
  lazy = true,
  cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
})

packadd({
  "nvim-telescope/telescope.nvim",
  lazy = true,
  cmd = "Telescope",
  version = false, -- telescope did only one release, so use HEAD for now
  config = require("tool.config.telescope"),
  dependencies = {
    { "nvim-telescope/telescope-live-grep-args.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim",    build = "make" },
  },
})
