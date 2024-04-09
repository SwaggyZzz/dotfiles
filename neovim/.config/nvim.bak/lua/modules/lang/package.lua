packadd({
  "simrat39/rust-tools.nvim",
  lazy = true,
  ft = "rust",
  config = require("lang.config.rust-tools"),
  dependencies = { "nvim-lua/plenary.nvim" },
})
