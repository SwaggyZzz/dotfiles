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
packadd({
  "j-hui/fidget.nvim",
  lazy = true,
  event = "LspAttach",
  config = require("ui.config.fidget"),
})

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
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = require("ui.config.alpha")
})

packadd({
  "lukas-reineke/indent-blankline.nvim",
  event = { "CursorHold", "CursorHoldI" },
  config = require("ui.config.indent-blankline"),
  main = "ibl"
})

packadd({
  "echasnovski/mini.indentscope",
  version = false, -- wait till new 0.7.0 release to put it back on semver
  event = { "BufReadPost", "BufAdd", "BufNewFile" },
  opts = {
    symbol = "│",
    options = { try_as_border = true },
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end
})

packadd({
  "folke/noice.nvim",
  event = "VeryLazy",
  config = function()
    require("ui.config.noice")
  end,
})
-- ui components
packadd({
  "MunifTanjim/nui.nvim",
  lazy = true
})
-- icons
packadd({
  "nvim-tree/nvim-web-devicons",
  lazy = true
})
-- better vim.ui
packadd({
  "stevearc/dressing.nvim",
  lazy = true,
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.select(...)
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.input = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.input(...)
    end
  end,
})
packadd({
  "rcarriga/nvim-notify",
  keys = {
    {
      "<leader>un",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Dismiss all Notifications",
    },
  },
  opts = {
    timeout = 3000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { zindex = 100 })
    end,
  },
  config = function()
    require("notify").setup({
      background_colour = "#000000",
    })
  end,
  init = function()
    local banned_messages = {
      "No information available",
      "LSP[tsserver] Inlay Hints request failed. Requires TypeScript 4.4+.",
      "LSP[tsserver] Inlay Hints request failed. File not opened in the editor.",
    }
    vim.notify = function(msg, ...)
      for _, banned in ipairs(banned_messages) do
        if msg == banned then
          return
        end
      end
      return require("notify")(msg, ...)
    end
  end,
})
