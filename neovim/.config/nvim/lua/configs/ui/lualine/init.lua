return function()
  local components = require("configs.ui.lualine.components")

  local opts = {
    options = {
      theme = "auto",
      globalstatus = vim.o.laststatus == 3,
      disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = {
        components.mode,
      },
      lualine_b = {
        components.filename,
      },
      lualine_c = {
        components.branch,
        components.diagnostics,
      },
      lualine_x = {
        components.diff,
        components.lsp,
        components.spaces,
      },
      lualine_y = { components.location },
      lualine_z = {
        components.progress,
      },
    },
  }

  require("lualine").setup(opts)
end
