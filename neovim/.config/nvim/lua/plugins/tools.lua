return {
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = {
      "NvimTreeToggle",
      "NvimTreeOpen",
      "NvimTreeFindFile",
      "NvimTreeFindFileToggle",
      "NvimTreeRefresh",
      "NvimTreeFocus"
    },
    config = require("configs.tools.nvim-tree")
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
    "ojroques/nvim-bufdel",
    lazy = true,
    cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    config = require("configs.tools.telescope"),
    dependencies = {
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim",    build = "make" },
    },
  },
}
