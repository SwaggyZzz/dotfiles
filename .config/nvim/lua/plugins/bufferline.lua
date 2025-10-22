return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  config = function()
    local mocha = require('catppuccin.palettes').get_palette 'mocha'
    local transparent_background = require('core.settings').transparent_background

    local icons = require 'core.icons'

    local opts = {
      options = {
        numbers = 'none',
        -- numbers = function(opts)
        --   return string.format("%s", opts.raise(opts.ordinal))
        -- end,
        -- close_command = function()
        --   Snacks.bufdelete()
        -- end,
        -- right_mouse_command = function()
        --   Snacks.bufdelete()
        -- end,
        color_icons = true,
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        -- diagnostics = false,
        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(num, _, diagnostics, _)
          local result = {}
          local symbols = {
            error = icons.diagnostics.Error,
            warning = icons.diagnostics.Warning,
            info = icons.diagnostics.Information,
          }
          for name, count in pairs(diagnostics) do
            if symbols[name] and count > 0 then
              table.insert(result, symbols[name] .. ' ' .. count)
            end
          end
          result = table.concat(result, ' ')
          return #result > 0 and result or ''
        end,
        separator_style = 'thin',
        indicator = {
          icon = icons.ui.BoldLineLeft,
          style = 'icon',
        },
        offsets = {
          {
            filetype = 'aerial',
            text = 'Symbol Outline',
            text_align = 'center',
            padding = 0,
            separator = true,
          },
          {
            filetype = 'snacks_layout_box',
            highlight = 'Directory',
            text = function()
              return '󰙅  ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
            end,
            separator = true,
          },
        },
      },
      highlights = require('catppuccin.special.bufferline').get_theme({
        custom = {
          all = {
            buffer_selected = {
              fg = mocha.peach,
              bg = transparent_background and 'NONE' or mocha.base,
              style = { 'bold', 'italic' },
            },
          },
        },
      }),
    }

    require('bufferline').setup(opts)
  end
}