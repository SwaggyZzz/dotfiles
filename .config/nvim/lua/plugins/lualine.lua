return {
  'nvim-lualine/lualine.nvim',
  event = 'BufWinEnter',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = require 'configs.ui.lualine',
}