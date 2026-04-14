return {
  'numToStr/Comment.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  config = function()
    -- skip backward compatibility routines and speed up loading
    vim.g.skip_ts_context_commentstring_module = true

    require('ts_context_commentstring').setup {
      enable_autocmd = false,
    }

    -- import comment plugin safely
    local comment = require 'Comment'

    local ts_context_commentstring = require 'ts_context_commentstring.integrations.comment_nvim'

    -- enable comment
    comment.setup {
      -- for commenting tsx, jsx, svelte, html files
      pre_hook = function(ctx)
        local ts_comment = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()(ctx)
        if ts_comment then
          return ts_comment
        end

        -- neovim 0.10+ 变动：vim.treesitter.get_parser 在没有 parser 时返回 nil 而非抛错
        -- 导致 Comment.nvim 在尝试获取没有对应 treesitter parser 的语言的注释格式时崩溃
        local ok, parser = pcall(vim.treesitter.get_parser, vim.api.nvim_get_current_buf())
        if not ok or not parser then
          return require('Comment.ft').get(vim.bo.filetype, ctx.ctype) or vim.bo.commentstring
        end
      end,
    }
  end,
}
