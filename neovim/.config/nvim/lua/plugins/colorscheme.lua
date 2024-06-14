return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      transparent_background = true,
      show_end_of_buffer = false, -- show the '~' characters after the end of buffers
      styles = {
        comments = { "italic" },
        conditionals = { "bold", "italic" },
        functions = { "bold" },
        constants = { "bold" },
        keywords = { "bold", "italic" },
      },
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        nvimtree = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
      -- highlight_overrides = {
      --   all = function(cp)
      --     local transparent_background = true
      --     return {
      --       -- For base configs
      --       NormalFloat = { fg = cp.text, bg = transparent_background and cp.none or cp.mantle },
      --       FloatBorder = {
      --         fg = transparent_background and cp.blue or cp.mantle,
      --         bg = transparent_background and cp.none or cp.mantle,
      --       },
      --
      --       -- For native lsp configs
      --       DiagnosticVirtualTextError = { bg = cp.none },
      --       DiagnosticVirtualTextWarn = { bg = cp.none },
      --       DiagnosticVirtualTextInfo = { bg = cp.none },
      --       DiagnosticVirtualTextHint = { bg = cp.none },
      --       LspInfoBorder = { link = "FloatBorder" },
      --
      --       -- For indent-blankline
      --       IblIndent = { fg = cp.surface0 },
      --       IblScope = { fg = cp.surface2, style = { "bold" } },
      --
      --       -- For nvim-cmp and wilder.nvim
      --       Pmenu = { fg = cp.overlay2, bg = transparent_background and cp.none or cp.base },
      --       PmenuBorder = { fg = cp.surface1, bg = transparent_background and cp.none or cp.base },
      --       PmenuSel = { bg = cp.green, fg = cp.base },
      --       CmpItemAbbr = { fg = cp.overlay2 },
      --       CmpItemAbbrMatch = { fg = cp.blue, style = { "bold" } },
      --       CmpDoc = { link = "NormalFloat" },
      --       CmpDocBorder = {
      --         fg = transparent_background and cp.surface1 or cp.mantle,
      --         bg = transparent_background and cp.none or cp.mantle,
      --       },
      --       -- For nvim-notify
      --       NotifyBackground = { bg = cp.base },
      --     }
      --   end,
      -- },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
