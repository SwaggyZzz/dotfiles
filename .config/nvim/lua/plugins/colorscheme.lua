return {
   {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    name = "catppuccin",
    config = function()
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
              -- 当前行行号颜色
              CursorLineNr = { fg = cp.green },

              -- For nvim-cmp
              PmenuSel = { bg = cp.green, fg = cp.base },
              Pmenu = { fg = cp.overlay2, bg = transparent_background and cp.none or cp.base },
              PmenuBorder = { fg = cp.surface1, bg = transparent_background and cp.none or cp.base },
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
    end,
  },
}