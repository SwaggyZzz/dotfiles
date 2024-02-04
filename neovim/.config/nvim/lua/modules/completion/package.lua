packadd({
  'neovim/nvim-lspconfig',
  lazy = true,
  event = { "BufReadPost", "BufAdd", "BufNewFile" },
  config = require("completion.config.lsp"),
  dependencies = {
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    {
      "jose-elias-alvarez/null-ls.nvim",
      config = require("completion.config.null-ls")
    },
    { "jose-elias-alvarez/typescript.nvim" },
    {
      "nvimdev/lspsaga.nvim",
      config = require("completion.config.lspsaga"),
    },
  },
})

packadd({
  "SmiteshP/nvim-navic",
  config = require("completion.config.navic"),
  dependencies = "neovim/nvim-lspconfig",
})

packadd({
  "js-everts/cmp-tailwind-colors",
  config = true,
})

-- packadd({
--   "pmizio/typescript-tools.nvim",
--   event = { "BufReadPre", "BufNewFile" },
--   ft = { "typescript", "typescriptreact" },
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "neovim/nvim-lspconfig",
--   },
--   config = function()
--     require("completion.config.typescript-tools")
--   end,
-- })

packadd({
  "hrsh7th/nvim-cmp",
  lazy = true,
  event = "InsertEnter",
  config = require("completion.config.cmp"),
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      dependencies = { "rafamadriz/friendly-snippets" },
      config = require("completion.config.lua-snip"),
    },
    { "onsails/lspkind.nvim" },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-calc" },
    { "hrsh7th/cmp-buffer" },
  },
})
