return {
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'BufWinEnter',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = require 'configs.ui.lualine',
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = require 'configs.ui.gitsigns',
  },
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    config = require 'configs.ui.bufferline',
  },
  {
    'gen740/SmoothCursor.nvim',
    event = 'VeryLazy',
    config = function()
      require('smoothcursor').setup {
        type = 'default',
        fancy = {
          enable = true, -- enable fancy mode
          -- head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil }, -- false to disable fancy head
          -- head = { cursor = "👉", texthl = "SmoothCursor", linehl = nil }, -- false to disable fancy head
          head = false,
          body = {
            { cursor = '󰝥', texthl = 'SmoothCursorRed' },
            { cursor = '󰝥', texthl = 'SmoothCursorOrange' },
            { cursor = '●', texthl = 'SmoothCursorYellow' },
            { cursor = '●', texthl = 'SmoothCursorGreen' },
            { cursor = '•', texthl = 'SmoothCursorAqua' },
            { cursor = '.', texthl = 'SmoothCursorBlue' },
            { cursor = '.', texthl = 'SmoothCursorPurple' },
          },
          tail = { cursor = nil, texthl = 'SmoothCursor' }, -- false to disable fancy tail
        },
      }
    end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
        signature = {
          enabled = true,
        },
        hover = {
          enabled = true,
          silent = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '; after #%d+' },
              { find = '; before #%d+' },
            },
          },
          view = 'mini',
        },
        {
          filter = {
            event = 'msg_show',
            kind = 'search_count',
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = 'notify',
            find = 'No information available',
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = 'msg_show',
            find = 'Keyboard interrupt',
          },
          opts = { skip = true },
        },
      },
    },
  },
  {
    'snacks.nvim',
    opts = {
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = false }, -- set this in options.lua
      words = { enabled = true },
      indent = {
        enabled = true,
        indent = {
          priority = 1,
          enabled = true, -- enable indent guides
          char = '┊',
          only_scope = false, -- only show indent guides of the scope
          only_current = false, -- only show indent guides in the current window
          hl = 'SnacksIndent',
          -- hl = {
          --   'SnacksIndent1',
          --   'SnacksIndent2',
          --   'SnacksIndent3',
          --   'SnacksIndent4',
          --   'SnacksIndent5',
          --   'SnacksIndent6',
          --   'SnacksIndent7',
          --   'SnacksIndent8',
          -- },
        },
        animate = {
          duration = {
            step = 10,
            duration = 100,
          },
        },
        scope = {
          enabled = true, -- enable highlighting the current scope
          priority = 200,
          char = '│',
          underline = false, -- underline the start of the scope
          only_current = true, -- only show scope in the current window
          hl = {
            'SnacksIndent1',
            'SnacksIndent2',
            'SnacksIndent3',
            'SnacksIndent4',
            'SnacksIndent5',
            'SnacksIndent6',
            'SnacksIndent7',
            'SnacksIndent8',
          },
        },
        chunk = {
          -- when enabled, scopes will be rendered as chunks, except for the top-level scope which will be rendered as a scope.
          enabled = true,
          hl = {
            'SnacksIndent1',
            'SnacksIndent2',
            'SnacksIndent3',
            'SnacksIndent4',
            'SnacksIndent5',
            'SnacksIndent6',
            'SnacksIndent7',
            'SnacksIndent8',
          },
        },
      },
    },
    keys = {
      {
        '<leader>n',
        function()
          if Snacks.config.picker and Snacks.config.picker.enabled then
            Snacks.picker.notifications()
          else
            Snacks.notifier.show_history()
          end
        end,
        desc = 'Notification History',
      },
      {
        '<leader>un',
        function()
          Snacks.notifier.hide()
        end,
        desc = 'Dismiss All Notifications',
      },
    },
  },

  {
    'snacks.nvim',
    opts = {
      dashboard = {
        preset = {
          header = [[
            ███████╗██╗    ██╗ █████╗  ██████╗  ██████╗██╗   ██╗███████╗
            ██╔════╝██║    ██║██╔══██╗██╔════╝ ██╔════╝╚██╗ ██╔╝╚══███╔╝
            ███████╗██║ █╗ ██║███████║██║  ███╗██║  ███╗╚████╔╝   ███╔╝
            ╚════██║██║███╗██║██╔══██║██║   ██║██║   ██║ ╚██╔╝   ███╔╝
            ███████║╚███╔███╔╝██║  ██║╚██████╔╝╚██████╔╝  ██║   ███████╗
            ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝   ╚═╝   ╚══════╝
          ]],
          keys = {
            { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
            { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
            { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
            { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
            { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
          },
        },
      },
    },
  },
}
