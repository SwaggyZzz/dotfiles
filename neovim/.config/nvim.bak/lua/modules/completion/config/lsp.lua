return function()
  require("completion.config.mason").setup()
  require("completion.config.mason-lspconfig").setup()
  require('completion.config.lsp-config')
  

  local ufo_config = require("editor.config.nvim-ufo")

  ufo_config()
end
