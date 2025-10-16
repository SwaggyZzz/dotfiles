return {
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
}
