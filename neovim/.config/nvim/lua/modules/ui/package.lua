-- packadd({
--   "sainnhe/everforest",
-- lazy = true,
--   name = "everforest"
-- })
-- packadd({
--   "Jint-lzxy/nvim",
--   lazy = true,
--   branch = "refactor/syntax-highlighting",
--   name = "catppuccin",
--   config = require("ui.config.catppuccin"),
-- })
packadd({
  "folke/tokyonight.nvim",
  -- lazy = true,
  -- lazy = false,
  -- priority = 1000,
  config = function()
    require("ui.config.tokynoight")
  end,
})
-- packadd({
--   "j-hui/fidget.nvim",
--   lazy = true,
--   event = "LspAttach",
--   config = require("ui.config.fidget"),
-- })

packadd({
  "akinsho/bufferline.nvim",
  lazy = true,
  event = { "BufReadPost", "BufAdd", "BufNewFile" },
  config = require("ui.config.bufferline"),
})
packadd({
  "nvim-lualine/lualine.nvim",
  lazy = true,
  event = { "BufReadPost", "BufAdd", "BufNewFile" },
  config = require("ui.config.lualine"),
})
packadd({
  "lewis6991/gitsigns.nvim",
  lazy = true,
  event = { "CursorHold", "CursorHoldI" },
  config = require("ui.config.gitsigns")
})

packadd({
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = require("ui.config.alpha")
})

packadd({
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = require("ui.config.indent-blankline"),
})

packadd({
  "nvim-tree/nvim-web-devicons",
  lazy = true,
  config = function()
    require("nvim-web-devicons").setup({ default = true })
  end,
})
packadd({
  "folke/noice.nvim",
  event = "VeryLazy",
  config = function()
    require("ui.config.noice")
  end,
})
packadd({
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  dependencies = "MunifTanjim/nui.nvim",
  config = function()
    require("ui.config.dressing")
  end,
})
