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

packadd({
  "nvim-tree/nvim-tree.lua",
  lazy = true,
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  config = require "tool.config.nvim-tree",
})

packadd({ "nvim-lua/plenary.nvim", lazy = true })