return {
  -- ================= UI ==================
  {
    'folke/snacks.nvim',
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
  -- ================= Dashboard ==================
  {
    'folke/snacks.nvim',
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
  -- ================= LSP ==================
  {
    'folke/snacks.nvim',
    keys = {
      -- LSP
      {
        'gd',
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = 'Goto Definition',
      },
      {
        'gD',
        function()
          Snacks.picker.lsp_declarations()
        end,
        desc = 'Goto Declaration',
      },
      {
        'gr',
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = 'References',
      },
      {
        'gI',
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = 'Goto Implementation',
      },
      {
        'gy',
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = 'Goto T[y]pe Definition',
      },
      {
        '<leader>ss',
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = 'LSP Symbols',
      },
      {
        '<leader>sS',
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = 'LSP Workspace Symbols',
      },
      {
        ']]',
        function()
          require('snacks').words.jump(vim.v.count1)
        end,
        desc = '[Snacks] Next Reference',
        mode = { 'n', 't' },
      },
      {
        '[[',
        function()
          require('snacks').words.jump(-vim.v.count1)
        end,
        desc = '[Snacks] Prev Reference',
        mode = { 'n', 't' },
      },
    },
  },
  -- ================= Tools ==================
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    config = function(_, opts)
      local notify = vim.notify
      require('snacks').setup(opts)
      -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
      -- this is needed to have early notifications show up in noice history
      vim.notify = notify
    end,
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      terminal = { enabled = false },
      explorer = { enabled = true },
      picker = {
        layout = {
          cycle = true,
          --- Use the default layout or vertical if the window is too narrow
          preset = function()
            return vim.o.columns >= 120 and 'default' or 'vertical'
          end,
        },
        win = {
          input = {
            keys = {
              ['<a-c>'] = {
                'toggle_cwd',
                mode = { 'n', 'i' },
              },
            },
          },
        },
        actions = {
          ---@param p snacks.Picker
          toggle_cwd = function(p)
            local root = require('lazyvim.util').root { buf = p.input.filter.current_buf, normalize = true }
            local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or '.')
            local current = p:cwd()
            p:set_cwd(current == root and cwd or root)
            p:find()
          end,
        },
        sources = {
          explorer = {
            layout = { layout = { position = 'left', size = 35 } },
            follow_file = true, -- 跟踪当前打开文件
            tree = true, -- 以树形结构显示
            focus = 'list', -- 默认焦点在文件列表
            jump = { close = true },
            auto_close = false,
            include = { 'node_modules', 'dist', '.eslintrc.js', '.prettierrc', '.gitignore', '.config' },
            win = {
              list = {
                keys = {
                  ['<BS>'] = 'explorer_up',
                  ['l'] = 'confirm',
                  ['h'] = 'explorer_close', -- close directory
                  ['a'] = 'explorer_add',
                  ['d'] = 'explorer_del',
                  ['r'] = 'explorer_rename',
                  ['c'] = 'explorer_copy',
                  ['m'] = 'explorer_move',
                  ['o'] = 'explorer_open', -- open with system application
                  ['P'] = 'toggle_preview',
                  ['y'] = { 'explorer_yank', mode = { 'n', 'x' } },
                  ['p'] = 'explorer_paste',
                  ['u'] = 'explorer_update',
                  ['<c-c>'] = 'tcd',
                  ['<leader>/'] = 'picker_grep',
                  ['<c-t>'] = 'terminal',
                  ['.'] = 'explorer_focus',
                  ['I'] = 'toggle_ignored',
                  ['H'] = 'toggle_hidden',
                  ['Z'] = 'explorer_close_all',
                  [']g'] = 'explorer_git_next',
                  ['[g'] = 'explorer_git_prev',
                  [']d'] = 'explorer_diagnostic_next',
                  ['[d'] = 'explorer_diagnostic_prev',
                  [']w'] = 'explorer_warn_next',
                  ['[w'] = 'explorer_warn_prev',
                  [']e'] = 'explorer_error_next',
                  ['[e'] = 'explorer_error_prev',
                },
              },
            },
          },
        },
      },
    },
    keys = {
      {
        '<leader>,',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<leader>/',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Buffer Lines',
      },
      {
        '<leader>:',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command History',
      },
      {
        '<leader><space>',
        function()
          Snacks.picker.pick 'files'
        end,
        desc = 'Find Files (Root Dir)',
      },
      -- find
      {
        '<leader>fb',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<leader>fB',
        function()
          Snacks.picker.buffers { hidden = true, nofile = true }
        end,
        desc = 'Buffers (all)',
      },
      {
        '<leader>ff',
        function()
          Snacks.picker.pick 'files'
        end,
        desc = 'Find Files (Root Dir)',
      },
      {
        '<leader>fF',
        function()
          Snacks.picker.pick('files', { cwd = require('lazyvim.util').root() })
        end,
        desc = 'Find Files (cwd)',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.git_files()
        end,
        desc = 'Find Files (git-files)',
      },
      {
        '<leader>fr',
        function()
          Snacks.picker.pick 'recent'
        end,
        desc = 'Recent',
      },
      {
        '<leader>fR',
        function()
          Snacks.picker.recent { filter = { cwd = true } }
        end,
        desc = 'Recent (cwd)',
      },
      {
        '<leader>fp',
        function()
          Snacks.picker.projects()
        end,
        desc = 'Projects',
      },
      -- git
      {
        '<leader>gd',
        function()
          Snacks.picker.git_diff()
        end,
        desc = 'Git Diff (hunks)',
      },
      {
        '<leader>gs',
        function()
          Snacks.picker.git_status()
        end,
        desc = 'Git Status',
      },
      {
        '<leader>gS',
        function()
          Snacks.picker.git_stash()
        end,
        desc = 'Git Stash',
      },
      -- Grep
      {
        '<leader>sb',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Buffer Lines',
      },
      {
        '<leader>sB',
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = 'Grep Open Buffers',
      },
      {
        '<leader>sg',
        function()
          Snacks.picker.pick 'live_grep'
        end,
        desc = 'Grep (Root Dir)',
      },
      {
        '<leader>sG',
        function()
          Snacks.picker.pick('live_grep', { cwd = require('lazyvim.util').root() })
        end,
        desc = 'Grep (cwd)',
      },
      {
        '<leader>sp',
        function()
          Snacks.picker.lazy()
        end,
        desc = 'Search for Plugin Spec',
      },
      {
        '<leader>sw',
        function()
          Snacks.picker.pick 'grep_word'
        end,
        mode = { 'n', 'x' },
      },
      {
        '<leader>sW',
        function()
          Snacks.picker.pick('grep_word', { cwd = require('lazyvim.util').root() })
        end,
        desc = 'Visual selection or word (cwd)',
        mode = { 'n', 'x' },
      },
      -- search
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = 'Registers',
      },
      {
        '<leader>s/',
        function()
          Snacks.picker.search_history()
        end,
        desc = 'Search History',
      },
      {
        '<leader>sa',
        function()
          Snacks.picker.autocmds()
        end,
        desc = 'Autocmds',
      },
      {
        '<leader>sc',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command History',
      },
      {
        '<leader>sC',
        function()
          Snacks.picker.commands()
        end,
        desc = 'Commands',
      },
      {
        '<leader>sd',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = 'Diagnostics',
      },
      {
        '<leader>sD',
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = 'Buffer Diagnostics',
      },
      {
        '<leader>sh',
        function()
          Snacks.picker.help()
        end,
        desc = 'Help Pages',
      },
      {
        '<leader>sH',
        function()
          Snacks.picker.highlights()
        end,
        desc = 'Highlights',
      },
      {
        '<leader>si',
        function()
          Snacks.picker.icons()
        end,
        desc = 'Icons',
      },
      {
        '<leader>sj',
        function()
          Snacks.picker.jumps()
        end,
        desc = 'Jumps',
      },
      {
        '<leader>sk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = 'Keymaps',
      },
      {
        '<leader>sl',
        function()
          Snacks.picker.loclist()
        end,
        desc = 'Location List',
      },
      {
        '<leader>sM',
        function()
          Snacks.picker.man()
        end,
        desc = 'Man Pages',
      },
      {
        '<leader>sm',
        function()
          Snacks.picker.marks()
        end,
        desc = 'Marks',
      },
      {
        '<leader>sR',
        function()
          Snacks.picker.resume()
        end,
        desc = 'Resume',
      },
      {
        '<leader>sq',
        function()
          Snacks.picker.qflist()
        end,
        desc = 'Quickfix List',
      },
      {
        '<leader>su',
        function()
          Snacks.picker.undo()
        end,
        desc = 'Undotree',
      },
      -- ui
      {
        '<leader>uC',
        function()
          Snacks.picker.colorschemes()
        end,
        desc = 'Colorschemes',
      },
      -- explorer
      {
        '<leader>fe',
        function()
          Snacks.explorer { cwd = require('lazyvim.util').root() }
        end,
        desc = 'Explorer Snacks (root dir)',
      },
      {
        '<leader>fE',
        function()
          Snacks.explorer()
        end,
        desc = 'Explorer Snacks (cwd)',
      },
      { '<leader>e', '<leader>fe', desc = 'Explorer Snacks (root dir)', remap = true },
      { '<leader>E', '<leader>fE', desc = 'Explorer Snacks (cwd)', remap = true },
      -- Other
      {
        '<leader>cR',
        function()
          Snacks.rename.rename_file()
        end,
        desc = 'Rename File',
      },
      {
        '<leader>gB',
        function()
          Snacks.gitbrowse()
        end,
        desc = 'Git Browse',
        mode = { 'n', 'v' },
      },
      {
        '<leader>gg',
        function()
          Snacks.lazygit()
        end,
        desc = 'Lazygit',
      },
    },
  },
}
