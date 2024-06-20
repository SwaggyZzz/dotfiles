return function()
  local transparent_background = require("core.settings").transparent_background

  require("catppuccin").setup({
    background = { light = "latte", dark = "mocha" }, -- latte, frappe, macchiato, mocha
    transparent_background = transparent_background,
    show_end_of_buffer = false, -- show the '~' characters after the end of buffers
    term_colors = true,
    styles = {
      comments = { "italic" },
      conditionals = { "bold", "italic" },
      functions = { "bold" },
      constants = { "bold" },
      keywords = { "bold", "italic" },
    },
    color_overrides = {},
    highlight_overrides = {
      ---@param cp palette
      all = function(cp)
        return {
          -- For base configs
          NormalFloat = { fg = cp.text, bg = transparent_background and cp.none or cp.mantle },
          FloatBorder = {
            fg = transparent_background and cp.blue or cp.mantle,
            bg = transparent_background and cp.none or cp.mantle,
          },
          CursorLineNr = { fg = cp.green },

          -- For native lsp configs
          DiagnosticVirtualTextError = { bg = cp.none },
          DiagnosticVirtualTextWarn = { bg = cp.none },
          DiagnosticVirtualTextInfo = { bg = cp.none },
          DiagnosticVirtualTextHint = { bg = cp.none },
          LspInfoBorder = { link = "FloatBorder" },

          -- For mason.nvim
          MasonNormal = { link = "NormalFloat" },

          -- For telescope.nvim
          TelescopeMatching = { fg = cp.lavender },

          -- For indent-blankline
          IblIndent = { fg = cp.surface0 },
          IblScope = { fg = cp.surface2, style = { "bold" } },

          -- For nvim-cmp
          PmenuSel = { bg = cp.green, fg = cp.base },
          Pmenu = { fg = cp.overlay2, bg = transparent_background and cp.none or cp.base },
          PmenuBorder = { fg = cp.surface1, bg = transparent_background and cp.none or cp.base },

          -- For nvim-notify
          NotifyBackground = { bg = cp.base },

          -- For nvim-tree
          NvimTreeRootFolder = { fg = cp.pink },
          NvimTreeIndentMarker = { fg = cp.surface2 },
        }
      end,
    },
    integrations = {
      aerial = true,
      alpha = true,
      dashboard = true,
      gitsigns = true,
      headlines = true,
      markdown = true,
      navic = { enabled = true, custom_bg = "lualine" },
      telescope = {
        enabled = true,
      },
      dropbar = {
        enabled = true,
        color_mode = true,
      },
      flash = true,
      barbar = true,
      leap = true,
      neotree = true,
      neotest = true,
      mason = true,
      noice = true,
      notify = true,
      which_key = true,
      semantic_tokens = true,
      mini = {
        enabled = true,
      },
      cmp = true,
      dap = true,
      dap_ui = true,
      treesitter_context = true,
      treesitter = true,
      window_picker = true,
      rainbow_delimiters = true,
      symbols_outline = true,
      lsp_trouble = true,
      illuminate = {
        enabled = true,
        lsp = true,
      },
      indent_blankline = {
        enabled = true,
        colored_indent_levels = true,
      },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },
        inlay_hints = {
          background = false,
        },
      },
    },
  })
end
