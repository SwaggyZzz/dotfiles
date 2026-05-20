return function()
  local components = require 'configs.lualine.components'
  local agentic_filetypes = { 'AgenticChat', 'AgenticInput', 'AgenticCode', 'AgenticFiles', 'AgenticDiagnostics' }

  -- vim.o.laststatus = vim.g.lualine_laststatus

  local opts = {
    options = {
      theme = 'auto',
      globalstatus = true,
      disabled_filetypes = {
        statusline = vim.list_extend({ 'snacks_dashboard', 'dashboard' }, vim.deepcopy(agentic_filetypes)),
        winbar = agentic_filetypes,
      },
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
