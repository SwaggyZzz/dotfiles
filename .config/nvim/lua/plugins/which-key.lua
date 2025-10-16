return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      ---@type false | "classic" | "modern" | "helix"
      preset = 'helix',
      win = {
        title = false,
        width = 0.4,
      },
    },
  }