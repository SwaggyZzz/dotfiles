packadd({
  "neovim/nvim-lspconfig",
  lazy = true,
  -- event = { "CursorHold", "CursorHoldI" }, -- 用这个事件需要手动触发 lsp vim.api.nvim_command([[LspStart]])
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  config = require("completion.config.lsp"),
  dependencies = {
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
  },
})

packadd({
  "williamboman/mason.nvim",
  cmd = "Mason",
  build = ":MasonUpdate",
  opts = {
    ensure_installed = {
      "stylua",
      "prettier",
      "shfmt",
    },
  },
  ---@param opts MasonSettings | {ensure_installed: string[]}
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require("mason-registry")
    mr:on("package:install:success", function()
      vim.defer_fn(function()
        -- trigger FileType event to possibly load this newly installed LSP server
        vim.api.nvim_exec_autocmds("FileType", {
          buffer = vim.api.nvim_get_current_buf(),
          modeline = false,
        })
      end, 100)
    end)
    local function ensure_installed()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end
    if mr.refresh then
      mr.refresh(ensure_installed)
    else
      ensure_installed()
    end
  end,
})

packadd({
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = "ConformInfo",
  dependencies = { "mason.nvim" },
  config = require("completion.config.conform"),
})

packadd({
  "hrsh7th/nvim-cmp",
  lazy = true,
  event = { "InsertEnter", "CmdlineEnter" },
  config = require("completion.config.cmp"),
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      dependencies = { "rafamadriz/friendly-snippets" },
      config = require("completion.config.luasnip"),
    },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    {
      "roobert/tailwindcss-colorizer-cmp.nvim",
      opts = {
        color_square_width = 2,
      },
    },
  },
})

packadd({
  "yioneko/nvim-vtsls",
  lazy = true,
  opts = {},
  config = function(_, opts)
    require("vtsls").config(opts)
  end,
})

-- packadd({
--   "antosha417/nvim-lsp-file-operations",
--   event = "LspAttach",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-tree/nvim-tree.lua",
--   },
--   config = function()
--     require("lsp-file-operations").setup()
--   end,
-- })
