return {
  {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    dependencies = {
      'rafamadriz/friendly-snippets',
      {
        'saghen/blink.compat',
        opts = {},
        version = '*',
      },
    },
    version = '*',
    opts = {
      appearance = {
        nerd_font_variant = 'mono',
        kind_icons = require('core.icons').kind,
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
            kind_resolution = {
              blocked_filetypes = { 'typescript', 'typescriptreact' },
            },
            semantic_token_resolution = {
              blocked_filetypes = { 'typescript', 'typescriptreact' },
            },
          },
        },
        list = {
          -- 预选第一项，切换时不自动插入
          selection = {
            preselect = function(ctx)
              return ctx.mode ~= 'cmdline'
            end,
            auto_insert = false,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = 'rounded',
            scrollbar = false,
          },
        },
        menu = {
          border = 'rounded',
          scrollbar = false,
          max_height = 15,
          draw = {
            treesitter = { 'lsp' },
            columns = {
              { 'kind_icon' },
              { 'label', 'label_description', 'source_name', gap = 1 },
            },
          },
        },
        ghost_text = {
          enabled = true,
        },
      },
      keymap = {
        preset = 'enter',
        ['<C-y>'] = { 'select_and_accept' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
      },
      signature = {
        enabled = false,
        window = {
          border = 'rounded',
        },
      },
      cmdline = {
        enabled = false,
        -- keymap = { preset = 'inherit' },
        -- completion = {
        --   menu = {
        --     auto_show = true,
        --   },
        -- },
      },
      sources = {
        default = function()
          local success, node = pcall(vim.treesitter.get_node)
          if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
            return { 'buffer' }
          else
            return {
              -- "lazydev", "copilot",
              'lsp',
              'path',
              'snippets',
              'buffer',
            }
          end
        end,
        providers = {
          -- path = {
          --   opts = {
          --     get_cwd = function(_)
          --       return vim.fn.getcwd()
          --     end,
          --   },
          -- },
          lsp = {
            -- Filter text items from the LSP provider, since we have the buffer provider for that
            transform_items = function(_, items)
              return vim.tbl_filter(function(item)
                return item.kind ~= require('blink.cmp.types').CompletionItemKind.Text
              end, items)
            end,
          },
        },
      },
    },
  },
}
