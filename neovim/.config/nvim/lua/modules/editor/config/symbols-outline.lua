return function()
  local symbolsOutline = require("symbols-outline")

  local icons = require('swaggyz.new-icons')
  local defaults = require("symbols-outline.config").defaults

  local opts = {
    symbols = {},
    symbol_blacklist = {},
  }

  local filter = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Package",
    "Property",
    "Struct",
    "Trait",
  }

  for kind, symbol in pairs(defaults.symbols) do
    opts.symbols[kind] = {
      icon = icons.git[kind] or symbol.icon,
      hl = symbol.hl,
    }
    if not vim.tbl_contains(filter, kind) then
      table.insert(opts.symbol_blacklist, kind)
    end
  end

  symbolsOutline.setup(opts)
end

