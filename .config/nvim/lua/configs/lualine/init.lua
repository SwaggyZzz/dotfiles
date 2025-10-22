return function()
  local components = require 'configs.lualine.components'

  -- vim.o.laststatus = vim.g.lualine_laststatus

  local opts = {
    options = {
      theme = 'auto',
      globalstatus = true,
      disabled_filetypes = { statusline = { 'snacks_dashboard', 'dashboard' } },
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = {
        components.mode,
      },
      lualine_b = {
        components.branch,
        components.diff,
      },
      lualine_c = {
        components.diagnostics,
        components.filename,
      },
      lualine_x = {
        components.lsp,
        components.spaces,
      },
      lualine_y = { components.location },
      lualine_z = {
        components.progress,
      },
    },
  }

  require('lualine').setup(opts)
end
