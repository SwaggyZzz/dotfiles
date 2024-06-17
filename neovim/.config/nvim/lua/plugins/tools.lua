return {
  -- 分屏跳转联动 tmux
  {
    "numToStr/Navigator.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "nvimdev/hlsearch.nvim",
    lazy = true,
    event = "BufRead",
    opts = {},
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {
      modes = {
        -- options used when flash is activated through
        -- a regular search with `/` or `?`
        search = {
          -- when `true`, flash will be activated during regular search by default.
          -- You can always toggle when searching with `require("flash").toggle()`
          enabled = true,
        },
      }
    },
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
    config = function(_, opts)
      local hls = {
        FlashBackdrop = { fg = "#545c7e" },
        FlashCurrent = { bg = "#ff966c", fg = "#1b1d2b" },
        FlashLabel = { bg = "#ff007c", bold = true, fg = "#c8d3f5" },
        FlashMatch = { bg = "#3e68d7", fg = "#c8d3f5" },
      }
      require("flash").setup(opts)
      vim.api.nvim_set_hl(0, "FlashLabel", { bg = "none", fg = "#F38BA8" })
    end
  },
}

-- local M = {}

-- M.base_30 = {
--   white = "#D9E0EE",
--   darker_black = "#191828",
--   black = "#1E1D2D", --  nvim bg
--   black2 = "#252434",
--   one_bg = "#2d2c3c", -- real bg of onedark
--   one_bg2 = "#363545",
--   one_bg3 = "#3e3d4d",
--   grey = "#474656",
--   grey_fg = "#4e4d5d",
--   grey_fg2 = "#555464",
--   light_grey = "#605f6f",
--   red = "#F38BA8",
--   baby_pink = "#ffa5c3",
--   pink = "#F5C2E7",
--   line = "#383747", -- for lines like vertsplit
--   green = "#ABE9B3",
--   vibrant_green = "#b6f4be",
--   nord_blue = "#8bc2f0",
--   blue = "#89B4FA",
--   yellow = "#FAE3B0",
--   sun = "#ffe9b6",
--   purple = "#d0a9e5",
--   dark_purple = "#c7a0dc",
--   teal = "#B5E8E0",
--   orange = "#F8BD96",
--   cyan = "#89DCEB",
--   statusline_bg = "#232232",
--   lightbg = "#2f2e3e",
--   pmenu_bg = "#ABE9B3",
--   folder_bg = "#89B4FA",
--   lavender = "#c7d1ff",
-- }

-- M.base_16 = {
--   base00 = "#1E1D2D",
--   base01 = "#282737",
--   base02 = "#2f2e3e",
--   base03 = "#383747",
--   base04 = "#414050",
--   base05 = "#bfc6d4",
--   base06 = "#ccd3e1",
--   base07 = "#D9E0EE",
--   base08 = "#F38BA8",
--   base09 = "#F8BD96",
--   base0A = "#FAE3B0",
--   base0B = "#ABE9B3",
--   base0C = "#89DCEB",
--   base0D = "#89B4FA",
--   base0E = "#CBA6F7",
--   base0F = "#F38BA8",
-- }
