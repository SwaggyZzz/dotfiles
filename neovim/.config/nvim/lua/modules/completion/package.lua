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
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        require("utils.format").register({
          name = "conform.nvim",
          priority = 100,
          primary = true,
          format = function(buf)
            local format_opts = require("core.settings").conform_format_opts
            ---@diagnostic disable-next-line: undefined-field
            require("conform").format(vim.tbl_deep_extend(
              "force",
              {},
              format_opts,
              { bufnr = buf }
            ))
          end,
          sources = function(buf)
            local ret = require("conform").list_formatters(buf)
            ---@param v conform.FormatterInfo
            return vim.tbl_map(function(v)
              return v.name
            end, ret)
          end,
        })
      end,
    })
  end,
  opts = function()
    ---@class ConformOpts
    local opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
      },
      -- The options you set here will be merged with the builtin formatters.
      -- You can also define any custom formatters here.
      ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
      formatters = {
        injected = { options = { ignore_errors = true } },
        prettier = {
          condition = function(_, ctx)
            -- vim.notify('======' .. ctx.dirname)
            -- for key, value in pairs(ctx) do
            --   vim.notify('======' .. key ..'===='..type(value))
            -- end
            -- return vim.fs.basename(ctx.filename) ~= "README.md"

            return not vim.fs.find(
              {
                "saas",
                "motor%-design"
              },
              {
                type = "directory",
                path = ctx.dirname,
                upward = true
              })[1]
          end,
        }
        -- # Example of using dprint only when a dprint.json file is present
        -- dprint = {
        --   condition = function(ctx)
        --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
        --
        -- # Example of using shfmt with extra args
        -- shfmt = {
        --   prepend_args = { "-i", "2", "-ci" },
        -- },
      },
    }
    return opts
  end,
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
