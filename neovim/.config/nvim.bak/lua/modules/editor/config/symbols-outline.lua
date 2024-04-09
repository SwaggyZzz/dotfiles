return function()
  local symbolsOutline = require("symbols-outline")

  local icons = require('swaggyz.new-icons')
  local defaults = require("symbols-outline.config").defaults

  local opts = {
    symbols = {},
    symbol_blacklist = {},
  }

  for kind, symbol in pairs(defaults.symbols) do
    opts.symbols[kind] = {
      icon = icons.kind[kind] or symbol.icon,
      hl = symbol.hl,
    }
  end

  symbolsOutline.setup(opts)
end
