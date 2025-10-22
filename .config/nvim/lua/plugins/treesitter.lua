return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPre', 'BufNewFile' },
    build = ':TSUpdate',
    dependencies = {
      -- { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    opts = {
      -- disable = function(lang, bufnr)
      --   return lang == 'yaml' and vim.api.nvim_buf_line_count(bufnr) > 5000
      -- end,
      highlight = { enable = true },
      indent = { enable = true },
      -- textobjects = {
      --   move = {
      --     enable = true,
      --     goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
      --     goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
      --     goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
      --     goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
      --   },
      --   select = {
      --     enable = true,
      --     keymaps = {
      --         ["af"] = "@function.outer",
      --         ["if"] = "@function.inner",
      --     },
      --   },
      -- },
      -- incremental_selection = {
      --   enable = true,
      --   keymaps = {
      --     init_selection = "<C-space>",
      --     node_incremental = "<C-space>",
      --     scope_incremental = false,
      --     node_decremental = "<bs>",
      --   },
      -- },
    },
    config = function(_, opts)
      local treesitter_parsers = require('core.settings').treesitter_parsers
      opts.ensure_installed = treesitter_parsers

      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      filetypes = {
        'html',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'vue',
        'xml',
      },
    },
  },
}
