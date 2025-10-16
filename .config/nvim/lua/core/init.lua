local leader_map = function()
  vim.g.mapleader = ' '
  -- NOTE:
  --  > Uncomment the following if you're using a <leader> other than <Space>, and you wish
  --  > to disable advancing one character by pressing <Space> in normal/visual mode.
  -- vim.api.nvim_set_keymap("n", " ", "", { noremap = true })
  -- vim.api.nvim_set_keymap("x", " ", "", { noremap = true })
end

local load_core = function()
  leader_map()

  require 'core.options'
  require 'core.mappings'
  require 'core.events'
  require 'core.lazy'
  -- require 'core.lsp'

  _G.LazyVim = require 'lazyvim.util'
end

load_core()
