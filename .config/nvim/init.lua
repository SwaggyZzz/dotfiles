if not vim.g.vscode then
  -- vim.lsp.set_log_level("debug")
  vim.g.mapleader = ' '

  require("core.options")
  require("core.events")
  require("core.keymaps")
  require("core.lazy")

  _G.LazyVim = require 'lazyvim.util'
end
