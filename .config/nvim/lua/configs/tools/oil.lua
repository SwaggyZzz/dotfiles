return function()
  local detail = false

  require('oil').setup {
    default_file_explorer = false,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = false,
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
      -- This function defines what will never be shown, even when `show_hidden` is set
      is_always_hidden = function(name, bufnr)
        return name == '..' or name == '.git'
      end,
      -- Sort file names with numbers in a more intuitive order for humans.
      -- Can be "fast", true, or false. "fast" will turn it off for large directories.
      natural_order = 'fast',
    },
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = { 'actions.close', mode = 'n' },
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },

      ['<C-h>'] = false,
      ['<C-l>'] = false,
      ['<C-r>'] = 'actions.refresh',
      ['<leader>y'] = 'actions.yank_entry',
      ['g.'] = 'actions.toggle_hidden',
      ['\\'] = { 'actions.select', opts = { horizontal = true } },
      ['|'] = { 'actions.select', opts = { vertical = true } },
      ['-'] = 'actions.close',
      ['<BS>'] = 'actions.parent',
      ['gd'] = {
        desc = 'Toggle file detail view',
        callback = function()
          detail = not detail
          if detail then
            require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' }
          else
            require('oil').set_columns { 'icon' }
          end
        end,
      },
    },
    win_options = {
      wrap = true,
    },
  }
end
