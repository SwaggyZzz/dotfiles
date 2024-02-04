return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
        disable = { "different-requires" },
      },
      -- Do not override treesitter lua highlighting with lua_ls's highlighting
      semantic = { enable = false },
    },
  },
}
