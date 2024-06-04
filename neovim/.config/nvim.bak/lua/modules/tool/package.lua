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

packadd({
  'numToStr/Navigator.nvim',
  event = "VeryLazy",
  config = function()
    vim.keymap.set({ 'n', 't' }, '<A-h>', '<CMD>NavigatorLeft<CR>')
    vim.keymap.set({ 'n', 't' }, '<A-l>', '<CMD>NavigatorRight<CR>')
    vim.keymap.set({ 'n', 't' }, '<A-k>', '<CMD>NavigatorUp<CR>')
    vim.keymap.set({ 'n', 't' }, '<A-j>', '<CMD>NavigatorDown<CR>')
    vim.keymap.set({ 'n', 't' }, '<A-p>', '<CMD>NavigatorPrevious<CR>')
    require('Navigator').setup()
  end
})

-- Session management. This saves your session in the background,
-- keeping track of open buffers, window arrangement, and more.
-- You can restore sessions when returning through the dashboard.
packadd({
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = { options = vim.opt.sessionoptions:get() },
  -- stylua: ignore
  keys = {
    { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
  },
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
