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

      -- nvim-treesitter main 使用 tree-sitter-cli 编译 parser。
      -- 安装是异步的，需要显式检查最终结果，否则失败只会留下短暂消息。
      vim.schedule(function()
        if vim.fn.executable('tree-sitter') ~= 1 then
          vim.notify_once(
            'nvim-treesitter 缺少 tree-sitter-cli；请执行 brew install tree-sitter-cli',
            vim.log.levels.ERROR
          )
          return
        end

        local ok, treesitter = pcall(require, 'nvim-treesitter')
        if not ok then
          vim.notify('加载 nvim-treesitter 失败：' .. tostring(treesitter), vim.log.levels.ERROR)
          return
        end

        treesitter.install(treesitter_parsers):await(function(err, installed)
          if err or not installed then
            vim.schedule(function()
              vim.notify(
                '部分 Treesitter parser 安装失败；请运行 :checkhealth nvim-treesitter 查看详情',
                vim.log.levels.ERROR
              )
            end)
          end
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
