return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
      -- { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    config = function()
      local treesitter_parsers = require('core.settings').treesitter_parsers

      -- 让 less 等文件使用 css 的 treesitter parser 进行解析
      pcall(vim.treesitter.language.register, 'css', 'less')

      -- As of nvim-treesitter rewrite for Nvim 0.12+, setup() is optional,
      -- and we install parsers via require('nvim-treesitter').install()
      vim.schedule(function()
        pcall(function()
          require('nvim-treesitter').install(treesitter_parsers)
        end)
      end)

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local bufnr = args.buf
          local lang = vim.bo[bufnr].filetype

          -- 禁用大文件的 treesitter 以避免卡顿
          local max_filesize = vim.g.bigfile_size or (1024 * 1024 * 1.5)
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
          if ok and stats and stats.size > max_filesize then
            return
          end

          -- 启动 treesitter highlight
          pcall(vim.treesitter.start, bufnr)

          -- 启用 treesitter indent
          -- 但在 TS/JS (包括 React) 中禁用，因为它在 AST 不完整时常常导致缩进错乱
          if lang == 'typescript' or lang == 'tsx' or lang == 'javascript' or lang == 'javascriptreact' then
            -- fallback 到 neovim 内置基于正则的缩进
          else
            vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
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
