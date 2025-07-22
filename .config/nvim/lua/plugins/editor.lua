return {
  -- {
  --   'nvimdev/hlsearch.nvim',
  --   lazy = true,
  --   event = 'BufRead',
  --   opts = {},
  -- },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      ignored_next_char = '[%w%.]', -- will ignore alphanumeric and `.` symbol
    },
  },
  {
    'echasnovski/mini.surround',
    event = 'BufReadPost',
    keys = function(_, keys)
      local opts_mappings = {
        add = 'gsa', -- Add surrounding in Normal and Visual modes
        delete = 'gsd', -- Delete surrounding
        find = 'gsf', -- Find surrounding (to the right)
        find_left = 'gsF', -- Find surrounding (to the left)
        highlight = 'gsh', -- Highlight surrounding
        replace = 'gsr', -- Replace surrounding
        update_n_lines = 'gsn', -- Update `n_lines`
      }
      local mappings = {
        { opts_mappings.add, desc = 'Add Surrounding', mode = { 'n', 'v' } },
        { opts_mappings.delete, desc = 'Delete Surrounding' },
        { opts_mappings.find, desc = 'Find Right Surrounding' },
        { opts_mappings.find_left, desc = 'Find Left Surrounding' },
        { opts_mappings.highlight, desc = 'Highlight Surrounding' },
        { opts_mappings.replace, desc = 'Replace Surrounding' },
        { opts_mappings.update_n_lines, desc = 'Update `MiniSurround.config.n_lines`' },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = 'gsa', -- Add surrounding in Normal and Visual modes
        delete = 'gsd', -- Delete surrounding
        find = 'gsf', -- Find surrounding (to the right)
        find_left = 'gsF', -- Find surrounding (to the left)
        highlight = 'gsh', -- Highlight surrounding
        replace = 'gsr', -- Replace surrounding
        update_n_lines = 'gsn', -- Update `n_lines`
      },
    },
  },
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      -- import comment plugin safely
      local comment = require 'Comment'

      local ts_context_commentstring = require 'ts_context_commentstring.integrations.comment_nvim'

      -- enable comment
      comment.setup {
        -- for commenting tsx, jsx, svelte, html files
        pre_hook = ts_context_commentstring.create_pre_hook(),
      }
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      highlight = {
        exclude = { 'big_file_disabled_ft', 'checkhealth' },
      },
    },
    keys = {
      {
        '<leader>st',
        function()
          Snacks.picker.todo_comments()
        end,
        desc = 'Todo',
      },
      {
        '<leader>sT',
        function()
          Snacks.picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } }
        end,
        desc = 'Todo/Fix/Fixme',
      },
    },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
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
      },
      label = {
        -- allow uppercase labels
        uppercase = false,
        rainbow = {
          enabled = true,
          shade = 1,
        },
      },
    },
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'o', 'x' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
    },
  },
  {
    'kevinhwang91/nvim-ufo',
    event = 'VeryLazy',
    dependencies = { 'kevinhwang91/promise-async' },
    config = require 'configs.editor.ufo',
  },
  {
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
    event = 'BufReadPost',
    config = function()
      local mc = require 'multicursor-nvim'
      mc.setup()

      local set = vim.keymap.set

      set('x', 'I', mc.insertVisual)
      set('x', 'A', mc.appendVisual)

      set({ 'n', 'v' }, '<C-n>', function()
        mc.matchAddCursor(1)
      end)
      set({ 'n', 'v' }, '<leader>s', function()
        mc.matchSkipCursor(1)
      end)
      set({ 'n', 'v' }, '<leader>S', function()
        mc.matchSkipCursor(-1)
      end)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ 'n', 'x' }, '<left>', mc.prevCursor)
        layerSet({ 'n', 'x' }, '<right>', mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ 'n', 'x' }, '<leader>x', mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet('n', '<esc>', function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)
    end,
  },
}
